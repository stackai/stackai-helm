# StackAI Local Infrastructure

This Terraform configuration sets up a complete local development environment for StackAI using Docker Desktop Kubernetes.

## Prerequisites

1. **Docker Desktop** with Kubernetes enabled
2. **Terraform** >= 1.0
3. **kubectl** configured to use Docker Desktop cluster
4. **Helm** >= 3.0

## Quick Start

1. **Enable Kubernetes in Docker Desktop**

   - Open Docker Desktop
   - Go to Settings > Kubernetes
   - Enable Kubernetes
   - Wait for the cluster to be ready

2. **Clone and setup**

   ```bash
   cd infra

   cp terraform.tfvars.example terraform.tfvars
   nano terraform.tfvars

   >>> You should see the ACR credentials in the file
   >>> acr_username = "username"
   >>> acr_password = "password"

   >>> Change the ACR credentials to your own and save and exit
   >>> How to get them? Send an email to [enterprise@stack-ai.com](mailto:enterprise@stack-ai.com?subject=ACR%20Credentials%20Request&body=Hello%20team%2C%0A%0AI%20would%20like%20to%20request%20access%20to%20the%20ACR%20credentials.%0A%0AThank%20you.)

   terraform init
   terraform plan
   terraform apply
   ```

3. **Access services**
   - Services Overview: <http://localhost>
   - ArgoCD: <http://argocd.localhost>
   - Supabase: <http://supabase.localhost>
   - Temporal Web: <http://temporal.localhost>
   - Weaviate: <http://weaviate.localhost>

## Architecture

### Namespaces

- `argocd` - ArgoCD for GitOps
- `stackai-infra` - Infrastructure components (nginx, supabase)
- `stackai-data` - Data stores (mongodb, redis, postgres, weaviate)
- `stackai-processing` - Processing services (temporal)

### Components

#### Infrastructure

- **Nginx Ingress Controller** - Load balancer and ingress
- **ArgoCD** - GitOps continuous delivery
- **Supabase** - Backend-as-a-Service (auth, db, api)

#### Data Stores

- **MongoDB** - Document database
- **Redis** - In-memory cache
- **PostgreSQL** - Relational database for Temporal
- **Weaviate** - Vector database

#### Processing

- **Temporal** - Workflow orchestration engine

## Configuration

### Environment Variables

All services use development values from `../dev-values/` directory:

- `mongodb-dev.yaml` - MongoDB configuration
- `redis-dev.yaml` - Redis configuration
- `postgres-dev.yaml` - PostgreSQL configuration
- `weaviate-dev.yaml` - Weaviate configuration
- `supabase-dev.yaml` - Supabase configuration
- `temporal-dev.yaml` - Temporal configuration
- `nginx-dev.yaml` - Nginx ingress configuration

### Customization

Edit `variables.tf` to customize:

- Domain name (default: localhost)
- Resource limits
- SSL/TLS settings

## Accessing Services

### ArgoCD

```bash
# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d

# Access UI
open http://argocd.localhost
```

### Supabase

- **Full Platform**: <http://supabase.localhost>
- **Admin**: supabase / stackai-dev-studio-password

### Temporal

- **Web UI**: <http://temporal.localhost>

### Weaviate

- **API & Console**: <http://weaviate.localhost>

### Data Stores

```bash
# MongoDB
mongosh "mongodb://admin:stackai-dev-password@localhost:27017/admin"

# Redis
redis-cli -h localhost -p 6379

# PostgreSQL
psql "postgresql://temporal:temporal-dev-password@localhost:5432/temporal"

# Weaviate
curl http://localhost:8080/v1/meta
```

## Port Forwarding

If services aren't accessible via localhost, use port forwarding:

```bash
# ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8080:80

# Supabase Kong
kubectl port-forward svc/supabase-kong -n stackai-infra 8000:8000

# Temporal Web
kubectl port-forward svc/temporal-web -n stackai-processing 8080:8080

# MongoDB
kubectl port-forward svc/mongodb -n stackai-data 27017:27017

# Redis
kubectl port-forward svc/redis -n stackai-data 6379:6379

# PostgreSQL
kubectl port-forward svc/postgres -n stackai-data 5432:5432

# Weaviate
kubectl port-forward svc/weaviate -n stackai-data 8080:8080
```

## Troubleshooting

### Check Pod Status

```bash
kubectl get pods -A
```

### Check Service Status

```bash
kubectl get svc -A
```

### View Logs

```bash
# ArgoCD
kubectl logs -l app.kubernetes.io/name=argocd-server -n argocd

# Supabase
kubectl logs -l app.kubernetes.io/component=auth -n stackai-infra

# Temporal
kubectl logs -l app.kubernetes.io/component=server -n stackai-processing
```

### Restart Services

```bash
# Restart all deployments in a namespace
kubectl rollout restart deployment -n stackai-infra
kubectl rollout restart deployment -n stackai-data
kubectl rollout restart deployment -n stackai-processing
```

### Check you are in the right context

```bash
# In local development you expect to be in docker-desktop context
kubectl config get-contexts
# Use the right context before run terraform apply
kubectl config use-context docker-desktop
```

## Cleanup

```bash
terraform destroy
```

## Development Workflow

1. **Make changes** to Helm charts in `../helm/`
2. **Update values** in `../dev-values/`
3. **Apply changes** via ArgoCD UI or:

   ```bash
   kubectl patch application stackai-infrastructure -n argocd --type merge -p '{"operation":{"sync":{"syncStrategy":{"force":true}}}}'
   ```

## Monitoring

### Resource Usage

```bash
kubectl top nodes
kubectl top pods -A
```

### Events

```bash
kubectl get events -A --sort-by='.lastTimestamp'
```

## Security Notes

- This setup is for **development only**
- All passwords are in plain text in dev-values
- No SSL/TLS by default
- CORS enabled for all origins
- Authentication disabled for development
