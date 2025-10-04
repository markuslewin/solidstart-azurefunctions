param repo string

module identity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
  params: {
    name: 'workflow'
    federatedIdentityCredentials: [
      {
        name: 'workflow-fid'
        issuer: 'https://token.actions.githubusercontent.com'
        subject: 'repo:${repo}:ref:refs/heads/main'
        audiences: [
          'api://AzureADTokenExchange'
        ]
      }
    ]
  }
}

module roleAssignment 'br/public:avm/res/authorization/role-assignment/rg-scope:0.1.0' = {
  params: {
    principalId: identity.outputs.principalId
    roleDefinitionIdOrName: 'Owner'
  }
}

type githubSecret = {
  name: string
  secret: string
}

output secrets githubSecret[] = [
  {
    name: 'AZURE_TENANT_ID'
    secret: tenant().tenantId
  }
  {
    name: 'AZURE_SUBSCRIPTION_ID'
    secret: subscription().subscriptionId
  }
  {
    name: 'AZURE_RESOURCE_GROUP_NAME'
    secret: resourceGroup().name
  }
  {
    name: 'AZURE_CLIENT_ID'
    secret: identity.outputs.clientId
  }
]
