# StackAI BYOC Local Deployment

This directory contains the configuration and scripts for deploying StackAI BYOC locally using Docker with Kubernetes.

## Prerequisites

1. **Docker Desktop with Kubernetes enabled**
   - Make sure Docker Desktop is running
   - Enable Kubernetes in Docker Desktop settings

2. **kubectl and helm installed**

   ```bash
   # Install kubectl (if not already installed)
   # macOS with Homebrew:
   brew install kubectl

   # Install helm (if not already installed)
   # macOS with Homebrew:
   brew install helm
   ```

3. **Azure Container Registry Access** (for stackend and stackweb images)
   - You need access to `stackai.azurecr.io`
   - Configure your ACR credentials

## Image Configuration

This local deployment uses a hybrid approach:

- **Azure Images** (require ACR access):
  - `stackend` (backend API)
  - `stackweb` (frontend)
  - `celery` (worker)

- **Public Images** (no authentication required):
  - MongoDB (Bitnami)
  - Redis (Bitnami)
  - Supabase components
  - Weaviate
  - Nginx Ingress Controller

## Quick Start

1. **Test the chart first** (recommended):

   ```bash
   ./test-chart.sh
   ```

2. **Deploy the application**:

   ```bash
   ./deploy-local.sh
   ```

3. **Access the application**:
   - StackWeb (Frontend): <http://localhost:30080/>
   - StackEnd (Backend API): <http://localhost:30080/users>, /organizations, etc.

## Configuration

The main configuration is in `values-local.yaml`. Key settings:

- **Storage**: Uses `standard` storage class (suitable for local testing)
- **Resources**: Reduced resource requirements for local testing
- **Ingress**: Uses NodePort with port 30080 for local access
- **Images**: Only stackend, stackweb, and celery use Azure images

## Troubleshooting

### Common Issues

1. **Image Pull Errors for Azure Images**:
   - Make sure you have ACR credentials configured
   - Check if the ACR secret is created properly

2. **Storage Issues**:
   - Ensure your Kubernetes cluster supports the `standard` storage class
   - For Docker Desktop, this should work out of the box

3. **Port Access Issues**:
   - Make sure port 30080 is not already in use
   - Check if the nginx-ingress service is running

### Useful Commands

```bash
# Check pod status
kubectl get pods -n stackai-local

# View logs
kubectl logs -f deployment/stackai-local-stackend -n stackai-local
kubectl logs -f deployment/stackai-local-stackweb -n stackai-local

# Check services
kubectl get services -n stackai-local

# Check ingress
kubectl get ingress -n stackai-local

# Delete the deployment
helm uninstall stackai-local -n stackai-local
kubectl delete namespace stackai-local
```

## File Structure

```
examples/helm/
├── README.md              # This file
├── deploy-local.sh        # Main deployment script
├── test-chart.sh         # Chart validation script
└── values-local.yaml     # Local deployment configuration
```
