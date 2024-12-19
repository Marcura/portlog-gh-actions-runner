targetScope = 'subscription'

@minLength(1)
@description('Primary location for all resources')
param location string
@secure()
param gitHubAppKey string
param subnetId string
param acaEnvName string

var project = 'aca-gh-runners'

var tags = {
  project: project
  repo: 'portlog-gh-actions-runner'
}

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${project}'
  location: location
  tags: tags
}

module resources 'resources.bicep' = {
  scope: rg
  name: 'deploy-resources'

  params: {
    location: location
    tags: union(tags, { module: '01-prerequisites/resources.bicep' })
    project: project
    gitHubAppKey: gitHubAppKey
    subnetId: subnetId
  }
}

output project string = project
output acrName string = resources.outputs.acrName
output acaEnvName string = acaEnvName
output acaMsiName string = resources.outputs.acaMsiName
output rgName string = rg.name
output gitHubAppKeySecretUri string = resources.outputs.gitHubAppKeySecretUri
