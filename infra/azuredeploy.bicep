// PARAMETERS
@description('Location to deploy resources')
param location string = resourceGroup().location

@description('Name of the Azure Container Registry')
param acrName string = 'myacrname' // 👈 Replace this or override via CLI

@description('Name of the App Service Plan')
param appServicePlanName string = 'todoapp-plan' // 👈 Change this to match your plan

@description('Name of the Web App')
param webAppName string = 'todoapp-webapp' // 👈 Customize your web app name

@description('Docker image tag to deploy')
param dockerImageTag string = 'todo-app:latest' // 👈 Make sure your image name matches

@description('MySQL host (FQDN)')
param dbHost string

@description('MySQL database name')
param dbName string

@description('MySQL user')
param dbUser string

@secure()
@description('MySQL password')
param dbPassword string

// RESOURCES

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'B1' // 👈 Use 'B1' for basic (paid), 'F1' for free (not Docker compatible)
    tier: 'Basic'
  }
  properties: {
    reserved: true // Required for Linux
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  kind: 'app,linux,container'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acr.properties.loginServer}/${dockerImageTag}'
      appSettings: [
        { name: 'WEBSITES_PORT'; value: '3000' }
        { name: 'DB_HOST'; value: dbHost }
        { name: 'DB_NAME'; value: dbName }
        { name: 'DB_USER'; value: dbUser }
        { name: 'DB_PASS'; value: dbPassword }
        { name: 'DOCKER_REGISTRY_SERVER_URL'; value: 'https://${acr.properties.loginServer}' }
        { name: 'DOCKER_REGISTRY_SERVER_USERNAME'; value: acr.listCredentials().username }
        { name: 'DOCKER_REGISTRY_SERVER_PASSWORD'; value: acr.listCredentials().passwords[0].value }
      ]
    }
  }
  dependsOn: [
    appServicePlan
    acr
  ]
}
