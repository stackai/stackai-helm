# StackAI Kubernetes Development Environment

This devcontainer provides a complete local Kubernetes development environment for StackAI infrastructure services including Temporal workflow engine and Unstructured document processing API.

## 🚀 Quick Start

1. **Open in VS Code**: Open this repository in VS Code with the Dev Containers extension installed
2. **Reopen in Container**: VS Code will prompt to reopen in container, or use `Ctrl+Shift+P` → "Dev Containers: Reopen in Container"
3. **Wait for Setup**: The initial setup will automatically:
   - Create a local Kubernetes cluster using Kind
   - Install ArgoCD for GitOps management
   - Set up all necessary tools and dependencies
4. **Deploy Services**: Run the deployment script:

   ```bash
   bash .devcontainer/start-services.sh
   ```

## 🏗️ Architecture

### Namespaces

- `stackai-infra`: Core infrastructure services (Supabase)
- `stackai-data`: Data services (MongoDB, Redis, Weaviate)
- `stackai-processing`: Processing services (Temporal, Unstructured)
- `stackai-gateway`: API Gateway and Ingress
- `argocd`: ArgoCD GitOps management
- `monitoring`: Monitoring stack (future)

### Services Included

#### Data Services (`stackai-data`)

- **MongoDB**: Document database for application data
- **Redis**: In-memory cache and message broker
- **Weaviate**: Vector database for AI/ML workloads

#### Infrastructure Services (`stackai-infra`)

- **Supabase**: Complete backend-as-a-service platform
  - PostgreSQL database with extensions
  - Authentication service (GoTrue)
  - API gateway (Kong)
  - Studio dashboard
  - Real-time subscriptions
  - Edge functions support

#### Processing Services (`stackai-processing`)

- **Temporal**: Workflow orchestration engine
  - Temporal Server (workflow execution)
  - Temporal Web UI (workflow monitoring)
- **Unstructured**: Document processing API
  - Text extraction and processing
  - Support for various document formats

#### Management Services

- **ArgoCD**: GitOps continuous deployment
- **NGINX Ingress**: Load balancer and ingress controller

## 🔧 Tools Included

### Kubernetes Tools

- `kubectl`: Kubernetes CLI
- `helm`: Package manager for Kubernetes
- `kind`: Kubernetes in Docker (local clusters)
- `k9s`: Interactive Kubernetes dashboard
- `stern`: Multi-pod log tailing
- `kubectx/kubens`: Context and namespace switching

### Development Tools

- `argocd`: ArgoCD CLI
- `telepresence`: Local development with remote clusters
- Docker and Docker Compose
- Git, curl, jq, yq

## 📊 Access Services

### Port Forwarding Scripts

Use the provided scripts to access services locally:

```bash
# ArgoCD UI (http://localhost:8080)
./scripts/port-forward-argocd.sh

# Supabase Studio (http://localhost:3000) & API (http://localhost:8000)
./scripts/port-forward-supabase.sh

# Temporal Web UI (http://localhost:8088) & Frontend (localhost:7233)
./scripts/port-forward-temporal.sh

# Unstructured API (http://localhost:8082)
./scripts/port-forward-unstructured.sh

# Weaviate (http://localhost:8081)
./scripts/port-forward-weaviate.sh

# MongoDB (localhost:27017)
./scripts/port-forward-mongodb.sh

# Redis (localhost:6379)
./scripts/port-forward-redis.sh
```

### Service Credentials

#### ArgoCD

- URL: <http://localhost:8080>
- Username: `admin`
- Password: Check `~/.argocd-password` or run `cat ~/.argocd-password`

#### Supabase

- Studio: <http://localhost:3000>
- API: <http://localhost:8000>
- Username: `supabase`
- Password: `stackai-dev-studio-password`
- JWT Secret: `stackai-dev-jwt-secret-with-at-least-32-characters-long`

#### Temporal

- Web UI: <http://localhost:8088>
- Frontend gRPC: localhost:7233
- No authentication required (development mode)

#### Unstructured

- API: <http://localhost:8082>
- Endpoint: `/general/v0/general`
- No authentication required (development mode)

#### MongoDB

- Host: localhost:27017
- Username: `admin`
- Password: `stackai-dev-password`
- Database: `admin`

#### Redis

- Host: localhost:6379
- No authentication required (development mode)

#### Weaviate

- URL: <http://localhost:8081>
- GraphQL endpoint: `/v1/graphql`
- Anonymous access enabled (development mode)

## 🔍 Monitoring and Debugging

### Interactive Dashboard

```bash
k9s
```

### Check Service Status

```bash
./scripts/check-services.sh
```

### View Logs

```bash
# All pods in all namespaces
./scripts/logs.sh all -f

# Specific service
./scripts/logs.sh temporal -f
./scripts/logs.sh unstructured -f
./scripts/logs.sh supabase --since 1h

# Traditional kubectl logs
kubectl logs -f deployment/temporal-server -n stackai-processing
kubectl logs -f deployment/unstructured -n stackai-processing
```

### Useful Aliases

The container includes helpful kubectl aliases:

- `k` = `kubectl`
- `kgp` = `kubectl get pods`
- `kgs` = `kubectl get svc`
- `kgn` = `kubectl get nodes`
- `kaf` = `kubectl apply -f`
- `kdel` = `kubectl delete`
- `klog` = `kubectl logs`
- `kexec` = `kubectl exec -it`

## 🎯 GitOps with ArgoCD

All services are managed through ArgoCD applications for a GitOps workflow:

1. **View Applications**: Access ArgoCD UI at <http://localhost:8080>
2. **Sync Applications**: Applications auto-sync when you modify Helm values
3. **Manual Sync**: Use ArgoCD UI or CLI to manually sync applications

### ArgoCD Applications

- `mongodb`: MongoDB database
- `redis`: Redis cache
- `weaviate`: Weaviate vector database
- `supabase`: Complete Supabase stack
- `temporal`: Temporal workflow engine
- `unstructured`: Unstructured document processing API

## 🛠️ Development Workflow

1. **Modify Helm Values**: Edit files in `dev-values/` directory
2. **Commit Changes**: ArgoCD will detect and sync changes automatically
3. **Monitor Deployment**: Use ArgoCD UI or `k9s` to monitor deployments
4. **Test Services**: Use port-forwarding scripts to access services locally

### Example: Testing Temporal Workflows

```bash
# Port forward Temporal
./scripts/port-forward-temporal.sh

# Access Temporal Web UI
open http://localhost:8088

# Connect to Temporal from your application
# Temporal Frontend: localhost:7233
```

### Example: Using Unstructured API

```bash
# Port forward Unstructured API
./scripts/port-forward-unstructured.sh

# Test the API
curl -X POST http://localhost:8082/general/v0/general \
  -F 'files=@your-document.pdf' \
  -H 'Content-Type: multipart/form-data'
```

## 📁 Directory Structure

```
.devcontainer/
├── devcontainer.json     # VS Code devcontainer configuration
├── Dockerfile           # Container image definition
├── setup.sh            # Initial environment setup
├── start-services.sh   # Deploy infrastructure services
└── docker-compose.yml  # Docker Compose configuration

dev-values/             # Helm values for development
├── mongodb-dev.yaml
├── redis-dev.yaml
├── weaviate-dev.yaml
├── supabase-dev.yaml
├── temporal-dev.yaml
└── unstructured-dev.yaml

argocd-apps/           # ArgoCD application definitions
├── mongodb-app.yaml
├── redis-app.yaml
├── weaviate-app.yaml
├── supabase-app.yaml
├── temporal-app.yaml
└── unstructured-app.yaml

scripts/               # Utility scripts
├── port-forward-*.sh  # Port forwarding scripts
├── check-services.sh  # Service status checker
└── logs.sh           # Comprehensive log viewing utility
```

## 🔧 Service Integration

### Temporal + Supabase Integration

Temporal is configured to use Supabase's PostgreSQL database:

```yaml
# In temporal-dev.yaml
env:
  POSTGRES_SEEDS: "supabase-db.stackai-infra.svc.cluster.local"
  POSTGRES_USER: "temporal"
```

### Unstructured + MongoDB Integration

Unstructured can optionally use MongoDB for persistence:

```yaml
# In unstructured-dev.yaml
env:
  DATABASE_URL: "mongodb://admin:stackai-dev-password@mongodb.stackai-data.svc.cluster.local:27017/unstructured"
```

### Service Discovery

All services can communicate using Kubernetes DNS:

- `mongodb.stackai-data.svc.cluster.local:27017`
- `redis.stackai-data.svc.cluster.local:6379`
- `weaviate.stackai-data.svc.cluster.local:8080`
- `supabase-kong.stackai-infra.svc.cluster.local:8000`
- `temporal-server.stackai-processing.svc.cluster.local:7233`
- `unstructured.stackai-processing.svc.cluster.local:8000`

## 🔄 Customization

### Adding New Services

1. Create Helm chart in `helm/infra/` or `helm/app/`
2. Add development values in `dev-values/`
3. Create ArgoCD application in `argocd-apps/`
4. Update `start-services.sh` to deploy the service
5. Add port forwarding script if needed

### Modifying Resources

Edit the corresponding `dev-values/*.yaml` file and ArgoCD will automatically sync the changes.

### Changing Ports

Update port mappings in:

- `.devcontainer/devcontainer.json` (forwardPorts)
- `.devcontainer/docker-compose.yml` (ports)
- Port forwarding scripts in `scripts/`

## 🚨 Troubleshooting

### Common Issues

#### Temporal Database Connection

If Temporal fails to connect to Supabase PostgreSQL:

```bash
# Check Supabase database is ready
kubectl logs -l app.kubernetes.io/component=db -n stackai-infra

# Check Temporal logs
./scripts/logs.sh temporal -f

# Restart Temporal
kubectl rollout restart deployment/temporal-server -n stackai-processing
```

#### Unstructured API Not Responding

```bash
# Check Unstructured logs
./scripts/logs.sh unstructured -f

# Test health endpoint
curl http://localhost:8082/general/v0/general

# Check resource usage
kubectl top pods -n stackai-processing
```

#### Service Discovery Issues

```bash
# Test DNS resolution from a pod
kubectl run -it --rm debug --image=busybox --restart=Never -- nslookup temporal-server.stackai-processing.svc.cluster.local

# Check service endpoints
kubectl get endpoints -n stackai-processing
```

For more troubleshooting, see `TROUBLESHOOTING.md`.

## 📚 Service Documentation

### Temporal

- [Temporal Documentation](https://docs.temporal.io/)
- [Temporal Samples](https://github.com/temporalio/samples)
- Web UI: Access workflow executions, schedules, and cluster status

### Unstructured

- [Unstructured Documentation](https://unstructured-io.github.io/unstructured/)
- [API Reference](https://unstructured-io.github.io/unstructured/apis/usage_methods.html)
- Supports: PDF, Word, PowerPoint, HTML, XML, and more

### Integration Examples

#### Using Temporal for Document Processing

```python
# Example workflow using Temporal + Unstructured
import asyncio
from temporalio import workflow
import aiohttp

@workflow.defn
class DocumentProcessingWorkflow:
    @workflow.run
    async def run(self, document_url: str) -> dict:
        # Download document
        # Process with Unstructured API
        # Store results in MongoDB
        # Update vector embeddings in Weaviate
        pass
```

## 🤝 Contributing

When adding new infrastructure services:

1. Follow the existing Helm chart structure
2. Add appropriate development values
3. Create ArgoCD applications
4. Update documentation
5. Test in the devcontainer environment

---

**Happy developing with the complete StackAI infrastructure stack! 🎉**
