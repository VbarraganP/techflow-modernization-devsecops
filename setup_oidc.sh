#!/bin/bash

APP_NAME="terraform-azure-connector" 
REPO="VbarraganP/techflow-modernization-devsecops"

APP_ID=$(az ad app list --display-name "$APP_NAME" --query "[0].id" -o tsv)

if [ -z "$APP_ID" ]; then
  echo "Error: No se encontró la aplicación '$APP_NAME'. Verifica el nombre."
  exit 1
fi

echo "Configurando credenciales federadas para la App: $APP_NAME ($APP_ID)"

echo "Creando credencial para la rama 'main'..."
az ad app federated-credential create \
  --id $APP_ID \
  --parameters "{\"name\":\"github-actions-main-001\",\"issuer\":\"https://token.actions.githubusercontent.com\",\"subject\":\"repo:$REPO:ref:refs/heads/main\",\"description\":\"GitHub Actions for main branch\",\"audiences\":[\"api://AzureADTokenExchange\"]}"

echo "Creando credencial para la rama 'develop'..."
az ad app federated-credential create \
  --id $APP_ID \
  --parameters "{\"name\":\"github-actions-develop-001\",\"issuer\":\"https://token.actions.githubusercontent.com\",\"subject\":\"repo:$REPO:ref:refs/heads/develop\",\"description\":\"GitHub Actions for develop branch\",\"audiences\":[\"api://AzureADTokenExchange\"]}"

echo "Creando credencial para Pull Requests..."
az ad app federated-credential create \
  --id $APP_ID \
  --parameters "{\"name\":\"github-actions-pr-001\",\"issuer\":\"https://token.actions.githubusercontent.com\",\"subject\":\"repo:$REPO:pull_request\",\"description\":\"GitHub Actions for pull requests\",\"audiences\":[\"api://AzureADTokenExchange\"]}"

echo "¡Listo! Credenciales federadas configuradas."
