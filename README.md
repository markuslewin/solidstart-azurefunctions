# SolidStart

Everything you need to build a Solid project, powered by [`solid-start`](https://start.solidjs.com);

## Creating a project

```bash
# create a new project in the current directory
npm init solid@latest

# create a new project in my-app
npm init solid@latest my-app
```

## Developing

Once you've created a project and installed dependencies with `npm install` (or `pnpm install` or `yarn`), start a development server:

```bash
npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

## Building

Solid apps are built with _presets_, which optimise your project for deployment to different environments.

By default, `npm run build` will generate a Node app that you can run with `npm start`. To use a different preset, add it to the `devDependencies` in `package.json` and specify in your `app.config.js`.

## This project was created with the [Solid CLI](https://github.com/solidjs-community/solid-cli)

## Set up resource group and workflow auth

### Using a script

Create a resource group and a federated identity for the workflow:

```bash
export SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export RESOURCE_GROUP="solidstart-azurefunctions"
export LOCATION="swedencentral"
export GITHUB_ORGANIZATION="markuslewin"
export GITHUB_REPOSITORY="solidstart-azurefunctions"
az group create --name $RESOURCE_GROUP --location $LOCATION
export PRINCIPAL_ID="$(az identity create --name workflow --resource-group $RESOURCE_GROUP --output tsv --query principalId)"
# The workflow needs a role that's authorized to assign roles to the function app
# [Use with `--assignee-object-id` to avoid errors caused by propagation latency in Microsoft Graph.](https://learn.microsoft.com/en-us/cli/azure/role/assignment?view=azure-cli-latest#az-role-assignment-create-optional-parameters)
az role assignment create --assignee-object-id $PRINCIPAL_ID --assignee-principal-type ServicePrincipal --role Owner --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP"
az identity federated-credential create --identity-name workflow --name workflow-fc --resource-group $RESOURCE_GROUP --audiences "api://AzureADTokenExchange" --issuer "https://token.actions.githubusercontent.com" --subject "repo:$GITHUB_ORGANIZATION/$GITHUB_REPOSITORY:ref:refs/heads/main"
```

Add the following secrets to the GitHub repository:

- `AZURE_CLIENT_ID` (Client ID of the workflow identity)
- `AZURE_RESOURCE_GROUP_NAME`
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_TENANT_ID`

### Using `azd`

- `azd pipeline config`

## Delete resources

```bash
az group delete --name $RESOURCE_GROUP
```
