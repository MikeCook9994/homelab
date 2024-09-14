@secure()
param deployerSudoPassword string

resource homelabManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' existing = {
  name: 'id-homelab-westus'
}

resource homelabKeyVault 'Microsoft.KeyVault/vaults@2024-04-01-preview' = {
  name: 'kv-homelab-westus'
  location: 'westus'
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: homelabManagedIdentity.properties.tenantId
    enabledForTemplateDeployment: true
    enableSoftDelete: false
    enableRbacAuthorization: true
  }
  resource deployerSudoPasswordSecret 'secrets' = {
    name: 'deployerSudoPassword'
    properties: {
      attributes: {
        enabled: true
      }
      value: deployerSudoPassword
    }
  }
}

func resolveRoleDefinitionId(assignmentScopeName string, assignmentTargetName string, roleDefinitionId string) string =>
  guid(assignmentScopeName, assignmentTargetName, roleDefinitionId)

var keyVaultReaderRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '21090545-7ca7-4776-b22c-e363652d74d2') // Key Vault Reader

resource homelabMSIKeyVaultReaderAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: resolveRoleDefinitionId(homelabKeyVault.name, homelabManagedIdentity.name, keyVaultReaderRoleDefinitionId)
  scope: homelabKeyVault
  properties: {
    roleDefinitionId: keyVaultReaderRoleDefinitionId
    principalId: homelabManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

var myPrincipalId = 'me@michaelcook.dev'

resource myKeyVaultReaderAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: resolveRoleDefinitionId(homelabKeyVault.name, myPrincipalId, keyVaultReaderRoleDefinitionId)
  scope: homelabKeyVault
  properties: {
    roleDefinitionId: keyVaultReaderRoleDefinitionId
    principalId: myPrincipalId
    principalType: 'User'
  }
}

var keyVaultSecretsUserRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6') // Key Vault Secrets User

resource homelabMSIKeyVaultSecretUserAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: resolveRoleDefinitionId(homelabKeyVault.name, homelabManagedIdentity.name, keyVaultSecretsUserRoleDefinitionId)
  scope: homelabKeyVault
  properties: {
    roleDefinitionId: keyVaultSecretsUserRoleDefinitionId
    principalId: homelabManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource myKeyVaultSecretUserAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: resolveRoleDefinitionId(homelabKeyVault.name, myPrincipalId, keyVaultSecretsUserRoleDefinitionId)
  scope: homelabKeyVault
  properties: {
    roleDefinitionId: keyVaultSecretsUserRoleDefinitionId
    principalId: myPrincipalId
    principalType: 'User'
  }
}
