param location string
param project string
param acrName string
param acrRgName string
param tags {
  *: string
}

@secure()
param gitHubAppKey string

var uniqueSuffix = uniqueString(subscription().id, location, project)

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
    acrName: acrName
    acrRgName: acrRgName
    kvName: keyVault.outputs.name
    location: location
    project: project
  }
}

output acaMsiName string = msi.outputs.msiName
output gitHubAppKeySecretUri string = keyVaultGitHubAppKey.outputs.uri
