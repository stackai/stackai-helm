# StackAI Values Configuration

This directory contains configuration values for StackAI infrastructure components organized by environment.

## Structure

- `dev/` - Development environment configurations
- `prod/` - Production environment configurations

## Development Environment (`dev/`)

### MongoDB (`dev/mongo-local.yaml`)

- Namespace: `mongodb`
- Authentication enabled with default credentials
- 5Gi persistent storage
- Resource limits: 512Mi memory, 500m CPU

### Redis (`dev/redis-local.yaml`)

- Namespace: `redis`
- Authentication disabled for local development
- 2Gi persistent storage
- Resource limits: 256Mi memory, 200m CPU

### Weaviate (`dev/weaviate-local.yaml`)

- Namespace: `weaviate`
- Anonymous access enabled
- 10Gi persistent storage
- Resource limits: 1Gi memory, 500m CPU

### Supabase (`dev/supabase-local.yaml`)

- Namespace: `supabase`
- Complete backend-as-a-service setup
- JWT authentication with demo keys
- All components enabled (Auth, REST, Realtime, Functions)

## Production Environment (`prod/`)

### MongoDB (`prod/mongo-production.yaml`)

- Authentication with external secrets
- 50Gi persistent storage with premium storage class
- Resource limits: 4Gi memory, 2000m CPU
- Production-optimized configuration

### Redis (`prod/redis-production.yaml`)

- Authentication enabled with external secrets
- 10Gi persistent storage with premium storage class
- Resource limits: 1Gi memory, 500m CPU
- Security and performance optimizations

### Weaviate (`prod/weaviate-production.yaml`)

- Authentication enabled with API keys
- 100Gi persistent storage with premium storage class
- Resource limits: 4Gi memory, 2000m CPU
- Monitoring and backup enabled

### Supabase (`prod/supabase-production.yaml`)

- External secrets from Azure Key Vault
- Production resource limits
- JWT verification enabled
- Email authentication enabled

## Usage

Values files are used by the deployment script with environment selection:

```bash
cd examples/infra
./deploy.sh dev    # Deploy with development configurations
./deploy.sh prod   # Deploy with production configurations
```

The script automatically applies the appropriate values files based on the environment parameter.
