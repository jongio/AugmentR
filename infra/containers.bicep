@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

param principalId string

var tags = {
  'azd-env-name': environmentName
}

// resource token for naming each resource randomly, reliably
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var identityName = 'id${resourceToken}'


module monitor './core/monitor/monitoring.bicep' = {
  name: 'monitor'
  params: {
    location: location
    logAnalyticsName: 'logs${resourceToken}'
    applicationInsightsName: 'ai${resourceToken}'
    tags: tags
    
  }
}

// Container apps host (including container registry)
module containerApps './core/host/container-apps.bicep' = {
  name: 'container-apps'
  params: {
    name: 'app'
    location: location
    containerAppsEnvironmentName: 'acae${resourceToken}'
    containerRegistryName: 'cr${resourceToken}'
    logAnalyticsWorkspaceName: monitor.outputs.logAnalyticsWorkspaceName
    tags: tags
  }
}

// create the redis container apps
module redis './core/host/container-app.bicep' = {
  name: 'redis'
  params: {
    name: 'rd${resourceToken}'
    location: location
    tags: tags
    identityName: identityName
    targetPort: 6379
    containerAppsEnvironmentName: containerApps.outputs.environmentName
    containerMaxReplicas: 1
    external: false
    serviceType: 'redis'
  }
}

// create the postgres container apps
module postgres './core/host/container-app.bicep' = {
  name: 'postgres'
  params: {
    name: 'pg${resourceToken}'
    location: location
    tags: tags
    identityName: identityName
    targetPort: 5432
    containerAppsEnvironmentName: containerApps.outputs.environmentName
    containerMaxReplicas: 1
    external: false
    serviceType: 'postgres'
  }
}

// create the qdrant container apps
module qdrant './core/host/container-app.bicep' = {
  name: 'qdrant'
  params: {
    name: 'qdrant${resourceToken}'
    location: location
    tags: tags
    identityName: identityName
    targetPort: 6333
    containerAppsEnvironmentName: containerApps.outputs.environmentName
    containerMaxReplicas: 1
    external: false
    imageName: 'qdrant/qdrant'
    containerName: 'qdrant'
  }
}

// allow acr pulls to the identity used for the aca's
module acrRole './core/security/registry-access.bicep' = {
  name: 'acrRole'
  params: {
    containerRegistryName: containerApps.outputs.registryName
    principalId: principalId
  }
}

// output environment variables
output AZURE_CONTAINER_REGISTRY string = containerApps.outputs.registryLoginServer
