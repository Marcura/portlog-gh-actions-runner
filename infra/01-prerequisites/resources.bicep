param location string
param project string
param tags {
  *: string
}

@secure()
param gitHubAppKey string

var uniqueSuffix = uniqueString(subscription().id, location, project)

module acr '../modules/containerRegistry.bicep' = {
  name: '${deployment().name}-acr'
  params: {
    location: location
    project: project
    tags: union(tags, { module: 'containerRegistry.bicep' })
    uniqueSuffix: uniqueSuffix
  }
}

module keyVault '../modules/keyVault.bicep' = {
  name: '${deployment().name}-kv'
  params: {
    location: location
    project: project
    tags: union(tags, { module: 'keyVault.bicep' })
    uniqueSuffix: uniqueSuffix
  }
}

module keyVaultGitHubAppKey '../modules/keyVaultSecret.bicep' = {
  name: '${deployment().name}-kv-github-app-key'
  params: {
    secretName: 'key-github-app'
    secretValue: gitHubAppKey
    tags: union(tags, {module: 'keyVaultSecret.bicep'})
    vaultName: keyVault.outputs.name
  }
}

module msi '../modules/containerAppIdentity.bicep' = {
  name: '${deployment().name}-msi'
  params: {
    acrName: acr.outputs.acrName
    kvName: keyVault.outputs.name
    location: location
    project: project
  }
}

output acrName string = acr.outputs.acrName
output acaMsiName string = msi.outputs.msiName
output gitHubAppKeySecretUri string = keyVaultGitHubAppKey.outputs.uri
