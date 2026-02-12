#!/bin/bash
set -e

BACKEND_RG="${BACKEND_RG:-rg-resource-admin}"
BACKEND_SA="${BACKEND_SA:-terraforminfrastates}"
BACKEND_CONTAINER="${BACKEND_CONTAINER:-tfstate}"

echo "----------------------------------------------------------------"
echo "Terraform Infrastructure Destruction"
echo "----------------------------------------------------------------"
echo "WARNING: This will PERMANENTLY DELETE resources."
echo "----------------------------------------------------------------"

if [ -z "$SUBSCRIPTION_ID" ]; then
    echo -n "Enter Subscription ID: "
    read SUBSCRIPTION_ID
fi

if [ -z "$SUBSCRIPTION_ID" ]; then
    echo "Error: Subscription ID is required."
    exit 1
fi

echo "Using Subscription ID: $SUBSCRIPTION_ID"

echo "Select environment to destroy:"
echo "1) Dev only"
echo "2) Prod only"
echo "3) Both (Dev then Prod)"
read -p "Selection [1-3]: " ENV_SELECTION

SECRET_VALUE="dummy-value-for-destroy"
CONTAINER_IMAGE="mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"

destroy_env() {
    ENV_NAME=$1
    TFVARS_FILE=$2

    echo ""
    echo "================================================================"
    echo "DESTROYING Environment: $ENV_NAME"
    echo "Using vars file: $TFVARS_FILE"
    echo "================================================================"

    terraform init -reconfigure \
        -backend-config="resource_group_name=${BACKEND_RG}" \
        -backend-config="storage_account_name=${BACKEND_SA}" \
        -backend-config="container_name=${BACKEND_CONTAINER}" \
        -backend-config="key=${ENV_NAME}.terraform.tfstate"

    MY_IP=$(curl -s ifconfig.me)
    if [ -z "$MY_IP" ]; then
         MY_IP="0.0.0.0/0"
    fi

    echo "Running Terraform Destroy..."
    terraform destroy -auto-approve \
        -var-file="${TFVARS_FILE}" \
        -var="subscription_id=${SUBSCRIPTION_ID}" \
        -var="secret_value=${SECRET_VALUE}" \
        -var="container_image=${CONTAINER_IMAGE}" \
        -var="allowed_ip_ranges=[\"${MY_IP}\"]"
}

cd "$(dirname "$0")/infra" || cd infra

if [ "$ENV_SELECTION" == "1" ]; then
    destroy_env "dev" "dev.tfvars"
elif [ "$ENV_SELECTION" == "2" ]; then
    destroy_env "prod" "prod.tfvars"
elif [ "$ENV_SELECTION" == "3" ]; then
    destroy_env "dev" "dev.tfvars"
    destroy_env "prod" "prod.tfvars"
else
    echo "Invalid selection. Exiting."
    exit 1
fi

echo ""
echo "----------------------------------------------------------------"
echo "Destruction complete!"
echo "----------------------------------------------------------------"
