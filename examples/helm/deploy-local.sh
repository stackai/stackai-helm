#!/bin/bash

# Local deployment script for StackAI BYOC
# This script deploys the StackAI application locally using the values-local.yaml configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed or not in PATH"
    exit 1
fi

# Check if helm is available
if ! command -v helm &> /dev/null; then
    print_error "helm is not installed or not in PATH"
    exit 1
fi

# Check if we're connected to a Kubernetes cluster
if ! kubectl cluster-info &> /dev/null; then
    print_error "Not connected to a Kubernetes cluster. Please ensure kubectl is configured."
    exit 1
fi

print_status "Starting local deployment of StackAI BYOC..."

# Create namespace if it doesn't exist
NAMESPACE="stackai-local"
print_status "Creating namespace: $NAMESPACE"
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Add required Helm repositories
print_status "Adding required Helm repositories..."
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install dependencies first
print_status "Installing MongoDB..."
helm upgrade --install mongodb bitnami/mongodb \
  --namespace $NAMESPACE \
  --values values-local.yaml \
  --set mongodb.enabled=true \
  --wait

print_status "Installing Redis..."
helm upgrade --install redis bitnami/redis \
  --namespace $NAMESPACE \
  --values values-local.yaml \
  --set redis.enabled=true \
  --wait

print_status "Installing Nginx Ingress Controller..."
helm upgrade --install nginx-ingress ingress-nginx/ingress-nginx \
  --namespace $NAMESPACE \
  --values values-local.yaml \
  --set nginx-ingress.enabled=true \
  --wait

# Deploy the main StackAI application
print_status "Deploying StackAI application..."
helm upgrade --install stackai-local . \
  --namespace $NAMESPACE \
  --values values-local.yaml \
  --wait

# Wait for all pods to be ready
print_status "Waiting for all pods to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=stackai-byoc -n $NAMESPACE --timeout=300s

# Get the service information
print_status "Getting service information..."
kubectl get services -n $NAMESPACE

# Get the ingress information
print_status "Getting ingress information..."
kubectl get ingress -n $NAMESPACE

# Display access information
print_status "Deployment completed successfully!"
echo ""
print_status "Access Information:"
echo "  - StackWeb (Frontend): http://localhost:30080/"
echo "  - StackEnd (Backend API): http://localhost:30080/users, /organizations, etc."
echo "  - MongoDB: Available internally on port 27017"
echo "  - Redis: Available internally on port 6379"
echo "  - Supabase: Available internally on various ports"
echo "  - Weaviate: Available internally on port 8080"
echo ""
print_warning "Note: Make sure you have the Azure Container Registry credentials configured if using Azure images for stackend and stackweb."
echo ""
print_status "To view logs:"
echo "  kubectl logs -f deployment/stackai-local-stackend -n $NAMESPACE"
echo "  kubectl logs -f deployment/stackai-local-stackweb -n $NAMESPACE"
echo ""
print_status "To delete the deployment:"
echo "  helm uninstall stackai-local -n $NAMESPACE"
echo "  kubectl delete namespace $NAMESPACE"
