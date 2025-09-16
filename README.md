# StackAI BYOC Helm Chart

A comprehensive Helm chart for deploying StackAI's Bring Your Own Cloud (BYOC) solution on Azure Kubernetes Service (AKS).

## Overview

This Helm chart deploys a complete StackAI platform including:

- **StackAI Backend** - Core API and business logic
- **StackAI Web Frontend** - User interface
- **Celery Workers** - Background task processing
- **MongoDB** - Primary database
- **Redis** - Caching and session storage
- **Supabase** - Authentication and real-time features
- **Weaviate** - Vector database for AI embeddings
- **Nginx Ingress** - Load balancing and SSL termination

## Prerequisites

- Kubernetes 1.24+
- Helm 3.0+
- Azure Kubernetes Service (AKS) cluster
- Azure Container Registry (ACR)
- Azure Key Vault (for secrets management)

## Installation

### 1. Add the Helm Repository

```bash
helm repo add stackai https://stackai.github.io/stackai-helm
helm repo update
```

### 2. Install the Chart

```bash
helm install stackai-byoc stackai/stackai-byoc \
  --namespace stackai \
  --create-namespace \
  --values values.yaml
```

### 3. Configure Azure Resources

Before installation, ensure you have the following Azure resources configured:

- **Azure Container Registry (ACR)**: For storing container images
- **Azure Key Vault**: For managing secrets
- **Azure Storage Account**: For persistent volumes
- **Azure DNS Zone**: For domain management (optional)

## Configuration

### Global Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.imageRegistry` | Global Docker image registry | `stackai.azurecr.io` |
| `global.imagePullSecrets` | Global image pull secrets | `[{"name": "acr-secret"}]` |
| `global.storageClass` | Global storage class | `managed-csi-premium` |
| `global.domain` | Global domain name | `""` |
| `global.tls.enabled` | Enable TLS | `false` |
| `global.tls.secretName` | TLS secret name | `""` |

### Azure Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `azure.resourceGroup` | Azure resource group name | `""` |
| `azure.subscriptionId` | Azure subscription ID | `""` |
| `azure.tenantId` | Azure tenant ID | `""` |
| `azure.keyVaultName` | Azure Key Vault name | `""` |
| `azure.acrName` | Azure Container Registry name | `stackai.azurecr.io` |
| `azure.nodeSelector.nodepool` | Node pool selector | `memory-optimized` |

### StackAI Backend Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `stackend.enabled` | Enable StackAI backend | `true` |
| `stackend.image.repository` | Backend image repository | `stackai/stackend-backend` |
| `stackend.image.tag` | Backend image tag | `latest` |
| `stackend.replicaCount` | Number of replicas | `1` |
| `stackend.service.type` | Service type | `ClusterIP` |
| `stackend.service.ports.api` | API port | `8000` |
| `stackend.service.ports.debug` | Debug port | `8888` |
| `stackend.resources.requests.cpu` | CPU request | `"6"` |
| `stackend.resources.requests.memory` | Memory request | `"16Gi"` |
| `stackend.resources.limits.cpu` | CPU limit | `"7"` |
| `stackend.resources.limits.memory` | Memory limit | `"20Gi"` |

### StackAI Web Frontend Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `stackweb.enabled` | Enable StackAI web frontend | `true` |
| `stackweb.image.repository` | Web image repository | `stackai/stackweb` |
| `stackweb.image.tag` | Web image tag | `latest` |
| `stackweb.replicaCount` | Number of replicas | `1` |
| `stackweb.service.type` | Service type | `ClusterIP` |
| `stackweb.service.ports.web` | Web port | `3000` |
| `stackweb.resources.requests.cpu` | CPU request | `"6"` |
| `stackweb.resources.requests.memory` | Memory request | `"16Gi"` |
| `stackweb.resources.limits.cpu` | CPU limit | `"7"` |
| `stackweb.resources.limits.memory` | Memory limit | `"20Gi"` |

### Celery Worker Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `celery.enabled` | Enable Celery worker | `true` |
| `celery.image.repository` | Celery image repository | `stackai/stackend-backend` |
| `celery.image.tag` | Celery image tag | `latest` |
| `celery.replicaCount` | Number of replicas | `1` |
| `celery.resources.requests.cpu` | CPU request | `"2"` |
| `celery.resources.requests.memory` | Memory request | `"4Gi"` |
| `celery.resources.limits.cpu` | CPU limit | `"4"` |
| `celery.resources.limits.memory` | Memory limit | `"8Gi"` |

### MongoDB Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `mongodb.enabled` | Enable MongoDB | `true` |
| `mongodb.auth.enabled` | Enable authentication | `true` |
| `mongodb.auth.rootPassword` | Root password | `""` |
| `mongodb.auth.username` | Username | `"stackai"` |
| `mongodb.auth.password` | Password | `""` |
| `mongodb.auth.database` | Database name | `"stackai"` |
| `mongodb.persistence.enabled` | Enable persistence | `true` |
| `mongodb.persistence.storageClass` | Storage class | `"managed-csi-premium"` |
| `mongodb.persistence.size` | Storage size | `20Gi` |

### Redis Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `redis.enabled` | Enable Redis | `true` |
| `redis.auth.enabled` | Enable authentication | `true` |
| `redis.auth.password` | Password | `""` |
| `redis.master.persistence.enabled` | Enable persistence | `true` |
| `redis.master.persistence.storageClass` | Storage class | `"managed-csi-premium"` |
| `redis.master.persistence.size` | Storage size | `10Gi` |

### Supabase Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `supabase.enabled` | Enable Supabase | `true` |
| `supabase.image.tag` | Supabase image tag | `"24.03.03"` |
| `supabase.db.enabled` | Enable database | `true` |
| `supabase.db.image.tag` | Database image tag | `"15.1.0.147"` |
| `supabase.db.persistence.enabled` | Enable persistence | `true` |
| `supabase.db.persistence.storageClass` | Storage class | `"managed-csi-premium"` |
| `supabase.db.persistence.size` | Storage size | `20Gi` |

### Weaviate Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `weaviate.enabled` | Enable Weaviate | `true` |
| `weaviate.image.tag` | Weaviate image tag | `"17.5.0"` |
| `weaviate.persistence.enabled` | Enable persistence | `true` |
| `weaviate.persistence.storageClass` | Storage class | `"managed-csi-premium"` |
| `weaviate.persistence.size` | Storage size | `20Gi` |

### Nginx Ingress Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nginx-ingress.enabled` | Enable nginx ingress | `true` |
| `nginx-ingress.controller.service.type` | Service type | `LoadBalancer` |
| `nginx-ingress.controller.resources.requests.cpu` | CPU request | `"0.5"` |
| `nginx-ingress.controller.resources.requests.memory` | Memory request | `"1Gi"` |
| `nginx-ingress.controller.resources.limits.cpu` | CPU limit | `"1"` |
| `nginx-ingress.controller.resources.limits.memory` | Memory limit | `"2Gi"` |

## Ingress Configuration

The chart includes comprehensive ingress configuration for both StackAI backend and web frontend:

### Backend Ingress

- **Host**: `stackai.example.com`
- **Paths**: Multiple API endpoints including `/users`, `/organizations`, `/projects`, etc.
- **Annotations**: CORS enabled, large body size support, extended timeouts

### Web Frontend Ingress

- **Host**: `stackai.example.com`
- **Path**: `/` (root path)
- **Annotations**: Large body size support, extended timeouts

## Secrets Management

The chart supports Azure Key Vault integration through External Secrets Operator:

- **ACR Secret**: For pulling images from Azure Container Registry
- **StackAI Licence**: For StackAI platform licensing
- **Supabase Secrets**: JWT, SMTP, dashboard, and database secrets

## Network Policies

The chart includes network policies for:

- Nginx ingress controller
- Inter-service communication
- External access control

## Resource Requirements

### Minimum Requirements

- **CPU**: 20+ cores
- **Memory**: 60+ GiB
- **Storage**: 100+ GiB

### Recommended Requirements

- **CPU**: 40+ cores
- **Memory**: 120+ GiB
- **Storage**: 200+ GiB

## Scaling

### Horizontal Scaling

- **Backend**: Scale `stackend.replicaCount`
- **Web Frontend**: Scale `stackweb.replicaCount`
- **Celery Workers**: Scale `celery.replicaCount`

### Vertical Scaling

Adjust resource requests and limits in the respective service configurations.

## Monitoring

The chart includes monitoring capabilities through:

- Health checks for all services
- Resource usage monitoring
- Log aggregation

## Troubleshooting

### Common Issues

1. **Image Pull Errors**: Ensure ACR credentials are properly configured
2. **Storage Issues**: Verify storage class and persistent volume claims
3. **Ingress Issues**: Check ingress controller and DNS configuration
4. **Database Connection**: Verify MongoDB and Redis connectivity

### Debug Commands

```bash
# Check pod status
kubectl get pods -n stackai

# Check logs
kubectl logs -n stackai deployment/stackend-backend

# Check ingress
kubectl get ingress -n stackai

# Check persistent volumes
kubectl get pv
```

## Upgrading

### Upgrade the Chart

```bash
helm upgrade stackai-byoc stackai/stackai-byoc \
  --namespace stackai \
  --values values.yaml
```

### Database Migrations

The chart includes a migration job that runs automatically during upgrades to handle database schema changes.

## Uninstalling

```bash
helm uninstall stackai-byoc -n stackai
```

**Warning**: This will delete all data. Ensure you have backups before uninstalling.

## Changelog

### v0.1.0

- Initial release
- Support for Azure Kubernetes Service
- Complete StackAI platform deployment
- Azure Key Vault integration
- Comprehensive monitoring and logging
