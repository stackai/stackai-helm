#!/bin/bash

set -e

# Colors for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo "🧪 Setting up Stackend Manual Test Environment..."

# Step 1: Kill processes using our ports
print_status "Freeing up ports..."
lsof -ti:8000 | xargs kill -9 2>/dev/null || true
lsof -ti:8080 | xargs kill -9 2>/dev/null || true
lsof -ti:3000 | xargs kill -9 2>/dev/null || true

# Step 2: Clean up any existing kind cluster
print_status "Cleaning up existing cluster..."
kind delete cluster --name stackai-dev 2>/dev/null || true

# Step 3: Create kind cluster with different ports
print_status "Creating kind cluster with fixed port mapping..."
cat <<KINDCONFIG > /tmp/kind-config-fixed.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: stackai-dev
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 8080
    protocol: TCP
  - containerPort: 443
    hostPort: 8443
    protocol: TCP
  - containerPort: 8000
    hostPort: 9000  # Changed from 8000 to 9000
    protocol: TCP
  - containerPort: 3000
    hostPort: 3001  # Changed from 3000 to 3001
    protocol: TCP
- role: worker
- role: worker
KINDCONFIG

kind create cluster --config /tmp/kind-config-fixed.yaml --wait 300s

print_success "Kind cluster created successfully!"

# Step 4: Set up kubeconfig
kubectl cluster-info

# Step 5: Create namespaces
print_status "Creating namespaces..."
kubectl create namespace stackai-data --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace stackai-infra --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace stackai-processing --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace stackai-app --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace nginx-ingress --dry-run=client -o yaml | kubectl apply -f -

print_success "Setup complete! Ready for service deployment."

