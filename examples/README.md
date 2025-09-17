# StackAI Infrastructure Examples

This directory contains examples for deploying StackAI infrastructure components using Helm charts with separate namespaces.

## Structure

- `infra/` - Infrastructure deployment examples
- `values/` - Custom values files for different environments

## Quick Start

Deploy all infrastructure components:

```bash
cd examples/infra
./deploy.sh
```

## Prerequisites

- Kubernetes cluster (1.19+)
- Helm 3.2.0+
- kubectl configured
- PersistentVolume provisioner support

## Infrastructure Components

Each component runs in its own namespace:

- **MongoDB** (`mongodb` namespace) - Document database
- **Redis** (`redis` namespace) - Caching and session storage
- **Weaviate** (`weaviate` namespace) - Vector database for AI/ML workloads
- **Supabase** (`supabase` namespace) - Complete backend-as-a-service with PostgreSQL, Auth, Realtime, etc.
- **Nginx Ingress Controller** (`nginx-ingress` namespace) - Routes all traffic using Supabase-style configuration

## Configuration

Each component can be customized using values files organized by environment in the `values/` directory:

### Development Environment (`values/dev/`)

- `values/dev/mongo-local.yaml` - MongoDB configuration
- `values/dev/redis-local.yaml` - Redis configuration
- `values/dev/weaviate-local.yaml` - Weaviate configuration
- `values/dev/supabase-local.yaml` - Supabase configuration

### Production Environment (`values/prod/`)

- `values/prod/mongo-production.yaml` - MongoDB configuration
- `values/prod/redis-production.yaml` - Redis configuration
- `values/prod/weaviate-production.yaml` - Weaviate configuration
- `values/prod/supabase-production.yaml` - Supabase configuration

## Architecture

```sh
Internet
    ↓
Nginx Ingress Controller (nginx-ingress namespace)
    ↓
┌─────────────────────────────────────┐
│ Infrastructure Services             │
│ ┌─────────┐ ┌─────┐ ┌───────────┐  │
│ │Supabase │ │Redis│ │Weaviate   │  │
│ │(supabase│ │redis│ │weaviate   │  │
│ │namespace│ │ns)  │ │namespace) │  │
│ └─────────┘ └─────┘ └───────────┘  │
│ ┌─────────────────────────────────┐ │
│ │ MongoDB (mongodb namespace)     │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

## Service Access

After deployment, services are accessible via:

- **Supabase Studio**: `http://<LB-IP>/studio/`
- **Supabase API**: `http://<LB-IP>/rest/v1/`
- **Auth API**: `http://<LB-IP>/auth/v1/`
- **Realtime**: `ws://<LB-IP>/realtime/v1/`
- **Functions**: `http://<LB-IP>/functions/v1/`

## Commands

```bash
# Deploy development environment
./deploy.sh deploy dev

# Deploy production environment
./deploy.sh deploy prod

# Check status
./deploy.sh status

# Get service URLs
./deploy.sh urls

# Cleanup
./deploy.sh cleanup
```
