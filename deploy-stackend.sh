#!/bin/bash

set -e

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo "🚀 Deploying Stackend..."

# Create stackend configuration
print_status "Creating stackend configuration..."
bash create-stackend-config.sh

# Deploy stackend
print_status "Deploying stackend to Kubernetes..."
helm upgrade --install stackend-test ./helm/app/stackend \
    --namespace stackai-app \
    --values stackend-test-values.yaml \
    --wait --timeout=600s

print_success "Stackend deployed!"

# Wait for pod to be ready
print_status "Waiting for stackend to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=stackend -n stackai-app --timeout=300s

print_success "Stackend is ready!"

# Show pod status
kubectl get pods -n stackai-app

