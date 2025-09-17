# StackAI Infrastructure Examples

This directory contains examples for deploying StackAI infrastructure components with separate namespaces and Supabase-style Nginx routing.

## Quick Start

Deploy all infrastructure components:

```bash
cd examples/infra
./deploy.sh
```

## Architecture

Each infrastructure component runs in its own namespace with Nginx routing traffic:

```sh
Internet → Nginx Ingress Controller (nginx-ingress namespace) → Services
                                    ├── /studio/* → Supabase Studio (supabase namespace)
                                    ├── /rest/v1/* → Supabase Kong (supabase namespace)
                                    ├── /auth/v1/* → Supabase Kong (supabase namespace)
                                    ├── /realtime/v1/* → Supabase Kong (supabase namespace)
                                    ├── /functions/v1/* → Supabase Kong (supabase namespace)
                                    ├── /analytics/v1/* → Supabase Kong (supabase namespace)
                                    ├── /sso/* → Supabase Kong (supabase namespace)
                                    └── /api/platform/* → Supabase Kong (supabase namespace)
```

## Files

### Deployment Files

- `deploy.sh` - Main deployment script
- `deploy-infrastructure.yaml` - Kubernetes manifests for namespaces and Nginx configuration
- `test.sh` - Test script to validate deployment

### Configuration

- `../values/dev/` - Development environment configurations
- `../values/prod/` - Production environment configurations

## Infrastructure Components

Each component runs in its own namespace:

1. **MongoDB** (`mongodb` namespace) - Document database
2. **Redis** (`redis` namespace) - Caching and session storage
3. **Weaviate** (`weaviate` namespace) - Vector database for AI/ML
4. **Supabase** (`supabase` namespace) - Complete backend-as-a-service
5. **Nginx Ingress Controller** (`nginx-ingress` namespace) - Routes all traffic

## Service Routing

### Supabase Services (via Kong)

- **`/rest/v1/*`** → PostgREST - Database API
- **`/graphql/v1/*`** → PostgREST - GraphQL API
- **`/auth/v1/*`** → GoTrue - Authentication
- **`/realtime/v1/*`** → Realtime - WebSocket connections
- **`/storage/v1/*`** → Storage API - File storage
- **`/functions/v1/*`** → Edge Functions - Serverless functions
- **`/analytics/v1/*`** → Analytics - Usage analytics
- **`/sso/*`** → SSO - Single sign-on
- **`/api/platform/*`** → Studio API - Admin API
- **`/studio/*`** → Supabase Studio - Admin dashboard (direct)

## Accessing Services

### After Deployment

1. **Get LoadBalancer IP:**

```bash
kubectl get svc nginx-ingress-controller -n nginx-ingress
```

2. **Access via LoadBalancer:**

- Infrastructure Status: `http://<LB-IP>/`
- Supabase Studio: `http://<LB-IP>/studio/`
- Supabase API: `http://<LB-IP>/rest/v1/`
- Auth API: `http://<LB-IP>/auth/v1/`

3. **Port Forward (if no LoadBalancer):**

```bash
kubectl port-forward -n nginx-ingress svc/nginx-ingress-controller 8080:80
# Access: http://localhost:8080
```

## Service Endpoints

For cross-namespace communication:

- MongoDB: `mongodb.mongodb.svc.cluster.local:27017`
- Redis: `redis.redis.svc.cluster.local:6379`
- Weaviate: `weaviate.weaviate.svc.cluster.local:8080`
- Supabase Kong: `supabase-kong.supabase.svc.cluster.local:8000`
- Supabase Studio: `supabase-studio.supabase.svc.cluster.local:3000`

## Commands

```bash
# Deploy development environment
./deploy.sh deploy dev

# Deploy production environment
./deploy.sh deploy prod

# Test deployment
./test.sh dev

# Check status
./deploy.sh status

# Get service URLs
./deploy.sh urls

# Cleanup
./deploy.sh cleanup
```

## Testing Endpoints

```bash
# Infrastructure status
curl http://<LB-IP>/

# Supabase API
curl http://<LB-IP>/rest/v1/ \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Authorization: Bearer YOUR_ANON_KEY"

# Supabase Studio
curl http://<LB-IP>/studio/
```

## Monitoring

### Check Status

```bash
# All namespaces
kubectl get namespaces -l app=stackai-infra

# Pods in all namespaces
for ns in mongodb redis weaviate supabase nginx-ingress; do
  echo "--- $ns namespace ---"
  kubectl get pods -n "$ns"
done

# Helm releases
helm list -A
```

### View Logs

```bash
# Nginx
kubectl logs -n nginx-ingress deployment/nginx-ingress-controller

# Supabase Kong
kubectl logs -n supabase deployment/supabase-kong

# MongoDB
kubectl logs -n mongodb deployment/mongodb
```

## Troubleshooting

### Common Issues

1. **Pods not starting**: Check resource limits and storage classes
2. **Services not accessible**: Verify LoadBalancer IP assignment
3. **Nginx routing issues**: Check ConfigMap and service names
4. **Cross-namespace connectivity**: Verify NetworkPolicy configuration

### Debug Commands

```bash
# Describe problematic pods
kubectl describe pod <pod-name> -n <namespace>

# Check service endpoints
kubectl get endpoints -A

# View Nginx configuration
kubectl get configmap supabase-nginx-config -n nginx-ingress -o yaml

# Test cross-namespace connectivity
kubectl run debug --image=busybox --rm -it --restart=Never -n nginx-ingress -- nslookup supabase-kong.supabase
```
