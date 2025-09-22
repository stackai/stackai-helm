#!/bin/bash

set -e

echo "🚀 Setting up StackAI Kubernetes Development Environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Wait for Docker to be ready
print_status "Waiting for Docker to be ready..."
while ! docker info > /dev/null 2>&1; do
    print_status "Docker is not ready yet, waiting..."
    sleep 2
done
print_success "Docker is ready!"

# Create kind cluster configuration
print_status "Creating kind cluster configuration..."
cat <<EOF > /tmp/kind-config.yaml
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
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
  - containerPort: 8080
    hostPort: 8080
    protocol: TCP
  - containerPort: 3000
    hostPort: 3000
    protocol: TCP
  - containerPort: 8000
    hostPort: 8000
    protocol: TCP
- role: worker
- role: worker
EOF

# Create kind cluster
print_status "Creating kind cluster 'stackai-dev'..."
if kind get clusters | grep -q "stackai-dev"; then
    print_warning "Kind cluster 'stackai-dev' already exists, deleting it first..."
    kind delete cluster --name stackai-dev
fi

kind create cluster --config /tmp/kind-config.yaml --wait 300s
print_success "Kind cluster created successfully!"

# Set up kubeconfig
print_status "Setting up kubeconfig..."
kind get kubeconfig --name stackai-dev > ~/.kube/config
chmod 600 ~/.kube/config
print_success "Kubeconfig configured!"

# Verify cluster is ready
print_status "Verifying cluster is ready..."
kubectl cluster-info
kubectl get nodes

# Create namespaces
print_status "Creating namespaces..."
kubectl create namespace stackai-infra --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace stackai-data --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace stackai-processing --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace stackai-gateway --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

kubectl create namespace stackai-app

# Label namespaces
kubectl label namespace stackai-infra name=stackai-infra --overwrite
kubectl label namespace stackai-data name=stackai-data --overwrite
kubectl label namespace stackai-processing name=stackai-processing --overwrite
kubectl label namespace stackai-gateway name=stackai-gateway --overwrite
kubectl label namespace argocd name=argocd --overwrite
kubectl label namespace monitoring name=monitoring --overwrite

print_success "Namespaces created and labeled!"

# Install ArgoCD
print_status "Installing ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
print_status "Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd
kubectl wait --for=condition=available --timeout=300s deployment/argocd-repo-server -n argocd
kubectl wait --for=condition=ready --timeout=300s pod -l app.kubernetes.io/name=argocd-application-controller -n argocd

# Patch ArgoCD server to use insecure mode for local development
print_status "Configuring ArgoCD for local development..."
kubectl patch configmap argocd-cmd-params-cm -n argocd --type merge -p '{"data":{"server.insecure":"true"}}'
kubectl rollout restart deployment argocd-server -n argocd
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

print_success "ArgoCD installed and configured!"

# Get ArgoCD initial admin password
print_status "Getting ArgoCD admin password..."
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "ArgoCD admin password: $ARGOCD_PASSWORD" > ~/.argocd-password
print_success "ArgoCD admin password saved to ~/.argocd-password"

# Install NGINX Ingress Controller
print_status "Installing NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Wait for NGINX Ingress to be ready
print_status "Waiting for NGINX Ingress Controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=300s

print_success "NGINX Ingress Controller installed!"

# Create storage class for local development
print_status "Creating local storage class..."
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Delete
EOF

# Remove default storage class annotation from standard class if it exists
kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}' 2>/dev/null || true

print_success "Local storage class configured!"

# Add Helm repositories
print_status "Adding Helm repositories..."
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

print_success "Helm repositories added!"

# Create directory for local development files
mkdir -p ~/.stackai-dev
cat <<EOF > ~/.stackai-dev/cluster-info.txt
StackAI Development Cluster Information
======================================

Cluster Name: stackai-dev
Kubeconfig: ~/.kube/config

Namespaces:
- stackai-infra: Infrastructure services (Supabase)
- stackai-data: Data services (MongoDB, Redis, Weaviate)
- stackai-processing: Processing services (Temporal, Unstructured)
- stackai-gateway: API Gateway and Ingress
- argocd: ArgoCD GitOps
- monitoring: Monitoring stack

ArgoCD:
- UI: http://localhost:8080
- Username: admin
- Password: $(cat ~/.argocd-password)

Useful Commands:
- k9s: Interactive Kubernetes dashboard
- kubectl get pods -A: Get all pods
- kubectl port-forward svc/argocd-server -n argocd 8080:443: Access ArgoCD UI
- stern <pod-name>: Stream logs from pods

Port Forwards (configured in devcontainer):
- 8080: ArgoCD UI
- 3000: Supabase Studio
- 8000: Supabase API Gateway
- 6379: Redis
- 27017: MongoDB
- 8081: Weaviate
EOF

print_success "Development environment setup complete!"
print_status "Cluster information saved to ~/.stackai-dev/cluster-info.txt"

echo ""
echo "🎉 StackAI Kubernetes Development Environment is ready!"
echo ""
echo "Next steps:"
echo "1. Run 'bash .devcontainer/start-services.sh' to deploy infrastructure services"
echo "2. Access ArgoCD UI at http://localhost:8080 (admin/$(cat ~/.argocd-password))"
echo "3. Use 'k9s' for an interactive Kubernetes dashboard"
echo "4. Use 'kubectl get pods -A' to see all running pods"
echo ""
