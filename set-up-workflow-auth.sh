#!/bin/bash

export RESOURCE_GROUP="solidstart-azurefunctions"
export LOCATION="swedencentral"
export REPO="markuslewin/solidstart-azurefunctions"

# Create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create federated identity for workflow
# Parse and set GitHub secrets for repo
gh secret set --env-file <(
  az deployment group create \
    --resource-group $RESOURCE_GROUP \
    --template-file infra/workflow-setup.bicep \
    --parameters repo=$REPO \
    --query properties.outputs.secrets.value \
      | jq -r '.[] | "\(.name)=\(.secret)"'
)

# All resources are created inside of the created resource group. To delete:
# az group delete --name $RESOURCE_GROUP