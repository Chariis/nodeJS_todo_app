# nodeJS_todo_app
## 🌐 Deployment Overview

This project is deployed to Microsoft Azure using:
- 🔸 Azure App Service (Web App for Containers)
- 🔸 Azure Database for PostgreSQL Flexible Server
- 🔸 Azure Container Registry (ACR)
- 🔸 GitHub Actions CI/CD Pipeline

---

## 🚀 Features

- ✅ Node.js backend API (CRUD Todo items)
- ✅ MySQL persistence (Flexible Server on Azure in production)
- ✅ Dockerized with multi-stage builds
- ✅ Docker Compose support for local development
- ✅ GitHub Actions CI/CD pipeline
- ✅ Azure App Service + ACR deployment
- ✅ Bicep IaC for consistent, automated provisioning

---

## 🧪 CI/CD Pipeline

- On every `main` push, GitHub Actions:
  1. Builds the Docker image
  2. Pushes it to ACR
  3. Deploys the image to Azure App Service

See: [.github/workflows/deploy-to-azure.yml](.github/workflows/deploy-to-azure.yml)

---

## 🧱 Infrastructure Diagram
                      +----------------------+
                      |  GitHub Repo         |
                      |  (Source + Workflows)|
                      +----------+-----------+
                                 |
                                 v
        +-----------------> GitHub Actions (CI/CD)
        |                        |
        |                        v
        |            Docker Build & Push to ACR
        |                        |
        |                        v
+----------------+        +--------------+
| Azure PostgreSQL|<----->| Azure Web App|
| Flexible Server |        | (Container) |
+----------------+        +--------------+
                                 ^
                                 |
                        Dockerized Python App

---

## 🔐 Secrets Management

Secrets (e.g., DB creds) are stored in:
- GitHub Repository Secrets (for CI)
- Azure App Configuration / Environment Variables (in App Service)

---

## 🛠️ Local Development

### 1. Copy `.env.example` to `.env` and fill in values:
```bash
cp .env.example .env
```

### 2. Start the app locally with Docker Compose:
```bash
docker compose up --build
```

### 3. Visit the app:
```
http://localhost:3000
```

---

## ☁️ Azure Deployment (Production)

### 1. Provision infrastructure using Bicep:

```bash
cd infra/
./deploy.sh
```

### 2. Add these secrets to your GitHub repository:

| Secret Name             | Description                      |
|--------------------------|----------------------------------|
| `AZURE_CREDENTIALS`      | JSON from `az ad sp create-for-rbac --sdk-auth` |
| `REGISTRY_NAME`          | Your ACR name (no `.azurecr.io`) |
| `REGISTRY_USERNAME`      | ACR admin username |
| `REGISTRY_PASSWORD`      | ACR admin password |
| `AZURE_WEBAPP_NAME`      | Name of your App Service |
| `DB_HOST`                | MySQL hostname (FQDN) |
| `DB_USER`                | MySQL user |
| `DB_PASS`                | MySQL password |
| `DB_NAME`                | Database name |

### 3. Push to main branch to trigger deployment:
```bash
git add .
git commit -m "Trigger deployment"
git push origin main
```

---

## 🔧 App Configuration (Azure)

Ensure these app settings exist in **Azure App Service → Configuration → Application Settings**:

| Setting       | Example Value                         |
|---------------|----------------------------------------|
| `MYSQL_HOST`  | `your-db.mysql.database.azure.com`     |
| `MYSQL_USER`  | `admin@your-db`                        |
| `MYSQL_PASSWORD` | `yourpassword`                     |
| `MYSQL_DB`    | `todoappDB`                            |
| `WEBSITES_PORT` | `3000` (Azure may set this automatically) |

---

## 🧪 Test Your Deployment

- Visit: `https://<your-app-name>.azurewebsites.net`
- Use Postman, curl, or the UI to interact with `/items` endpoints

---

## 📘 Documentation

- [Azure App Service (Linux)](https://docs.microsoft.com/azure/app-service/)
- [Azure Container Registry](https://docs.microsoft.com/azure/container-registry/)
- [Bicep Templates](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
- [GitHub Actions for Azure](https://github.com/Azure/actions)

---

## 💡 Future Improvements

- Add unit tests + GitHub Actions test stage
- Add Redis for caching
- Switch to Key Vault for secret management
- Add monitoring with Azure Monitor or Application Insights

---

## 🧑‍💻 Author

**Chigozie**  
DevOps & Cloud Engineer in Progress 🚀  
GitHub: Chariis(https://github.com/Chariis)

---
