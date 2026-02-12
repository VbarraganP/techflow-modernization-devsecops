#!/bin/bash
set -e

BACKEND_RG="${BACKEND_RG:-rg-resource-admin}"
BACKEND_SA="${BACKEND_SA:-terraforminfrastates}"
BACKEND_CONTAINER="${BACKEND_CONTAINER:-tfstate}"
LOCATION="${LOCATION:-eastus}"

echo "----------------------------------------------------------------"
echo "Check and Register Resource Providers"
echo "----------------------------------------------------------------"
az provider register --namespace Microsoft.App
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.OperationalInsights
echo "Providers registered (async operation, proceeding...)"

echo "----------------------------------------------------------------"
echo "Terraform Infrastructure Initialization"
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

echo -n "Enter value for 'secret_value' (sensitive, will be hidden): "
read -s SECRET_VALUE
echo ""

if [ -z "$SECRET_VALUE" ]; then
    echo "Error: secret_value cannot be empty."
    exit 1
fi

deploy_env() {
    ENV_NAME=$1
    TFVARS_FILE=$2

    echo ""
    echo "================================================================"
    echo "Deploying Environment: $ENV_NAME"
    echo "Using vars file: $TFVARS_FILE"
    echo "================================================================"

    terraform init -reconfigure \
        -backend-config="resource_group_name=${BACKEND_RG}" \
        -backend-config="storage_account_name=${BACKEND_SA}" \
        -backend-config="container_name=${BACKEND_CONTAINER}" \
        -backend-config="key=${ENV_NAME}.terraform.tfstate"

    echo "Running Terraform Apply..."
    
    terraform apply -auto-approve \
        -var-file="${TFVARS_FILE}" \
        -var="subscription_id=${SUBSCRIPTION_ID}" \
        -var="secret_value=${SECRET_VALUE}"
}

cd "$(dirname "$0")/infra" || cd infra

if [[ ! -f "dev.tfvars" ]] || [[ ! -f "prod.tfvars" ]]; then
    echo "Error: dev.tfvars or prod.tfvars not found in $(pwd)!"
    exit 1
fi

deploy_env "dev" "dev.tfvars"

deploy_env "prod" "prod.tfvars"

echo ""
echo "----------------------------------------------------------------"
echo "Infrastructure initialization complete!"
echo "----------------------------------------------------------------"
