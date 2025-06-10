#!/bin/bash

# === USER INPUT SECTION ===
RG_NAME="todoapp-rg"                     # 👈 Replace with your resource group name
LOCATION="eastus"                        # 👈 Set to your preferred region
ACR_NAME="todoacr123"                    # 👈 Unique ACR name
PLAN_NAME="todoapp-plan"                # 👈 App Service plan name
WEBAPP_NAME="todoapp-web"               # 👈 App Service name
DOCKER_IMAGE_TAG="todo-app:latest"      # 👈 Your pushed image tag

# === MYSQL DB CONFIG ===
DB_HOST="your-db.mysql.database.azure.com"     # 👈 Replace with your MySQL server FQDN
DB_NAME="todoappDB"                            # 👈 Replace with your DB name
DB_USER="mysqladmin@your-db"                  # 👈 Replace with DB username
DB_PASS="yourpassword"                         # 👈 Replace with DB password

# === DEPLOYMENT ===
echo "Deploying Azure resources using Bicep..."

az deployment group create \
  --name deploy-todoapp \
  --resource-group "$RG_NAME" \
  --template-file ./infra/azuredeploy.bicep \
  --parameters \
    location="$LOCATION" \
    acrName="$ACR_NAME" \
    appServicePlanName="$PLAN_NAME" \
    webAppName="$WEBAPP_NAME" \
    dockerImageTag="$DOCKER_IMAGE_TAG" \
    dbHost="$DB_HOST" \
    dbName="$DB_NAME" \
    dbUser="$DB_USER" \
    dbPassword="$DB_PASS"
