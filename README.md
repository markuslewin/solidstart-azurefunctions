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

## Authenticating the workflow

The Bicep file `infra/workflow-setup.bicep` creates a federated identity for the workflow. The required secrets are output:

```bash
export RESOURCE_GROUP="solidstart-azurefunctions"
export LOCATION="swedencentral"
export REPO="markuslewin/solidstart-azurefunctions"

# Create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create federated identity for workflow
az deployment group create --resource-group $RESOURCE_GROUP --template-file infra/workflow-setup.bicep --parameters repo=$REPO --query properties.outputs.secrets.value
```

The output secrets can be manually copy-pasted into the GitHub UI, but it's also possible to automate this step by formatting the output with `jq` and setting the secrets with `gh` like so:

```bash
# Create temporary file for secrets
export SECRETS_FILE=$(mktemp)

# Write dotenv-formatted Bicep outputs to secrets file
jq -r '.[] | "\(.name)=\(.secret)"' > $SECRETS_FILE

# Set repository secrets
gh secret set --env-file $SECRETS_FILE
```

In one script:

```bash
export RESOURCE_GROUP="solidstart-azurefunctions"
export LOCATION="swedencentral"
export REPO="markuslewin/solidstart-azurefunctions"
export SECRETS_FILE=$(mktemp)
az group create --name $RESOURCE_GROUP --location $LOCATION
az deployment group create --resource-group $RESOURCE_GROUP --template-file infra/workflow-setup.bicep --parameters repo=$REPO --query properties.outputs.secrets.value | jq -r '.[] | "\(.name)=\(.secret)"' > $SECRETS_FILE
gh secret set --env-file $SECRETS_FILE
```

## Delete Azure resources

```bash
az group delete --name $RESOURCE_GROUP
```
