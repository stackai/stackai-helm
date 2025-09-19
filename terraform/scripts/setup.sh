#!/bin/bash

# StackAI Local Infrastructure Setup Script
set -e

echo "🚀 Setting up StackAI Local Infrastructure..."

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed. Please install Terraform >= 1.0"
    exit 1
fi

if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed. Please install kubectl"
    exit 1
fi

if ! command -v helm &> /dev/null; then
    echo "❌ Helm is not installed. Please install Helm >= 3.0"
    exit 1
fi

# Check if Docker Desktop Kubernetes is running
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Kubernetes cluster is not accessible. Please ensure Docker Desktop Kubernetes is enabled"
    exit 1
fi

echo "✅ All prerequisites met"

# Check if kubeconfig is pointing to Docker Desktop
CLUSTER_NAME=$(kubectl config current-context)
if [[ ! "$CLUSTER_NAME" == *"docker-desktop"* ]]; then
    echo "⚠️  Warning: Current kubectl context '$CLUSTER_NAME' doesn't appear to be Docker Desktop"
    echo "   Please ensure you're using the Docker Desktop Kubernetes cluster"
    read -p "   Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Initialize Terraform
echo "🔧 Initializing Terraform..."
terraform init

# Copy terraform.tfvars if it doesn't exist
if [ ! -f "terraform.tfvars" ]; then
    echo "📝 Creating terraform.tfvars from example..."
    cp terraform.tfvars.example terraform.tfvars
    echo "   Please review terraform.tfvars and customize if needed"
fi

# Plan the deployment
echo "📋 Planning Terraform deployment..."
terraform plan

# Ask for confirmation
echo "🚀 Ready to deploy StackAI infrastructure to Docker Desktop Kubernetes"
echo "   This will create:"
echo "   - 4 namespaces (argocd, stackai-infra, stackai-data, stackai-processing)"
echo "   - ArgoCD for GitOps"
echo "   - Nginx Ingress Controller"
echo "   - MongoDB, Redis, PostgreSQL, Weaviate"
echo "   - Supabase and Temporal"
echo ""
read -p "Continue with deployment? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled"
    exit 0
fi

# Apply the configuration
echo "🚀 Deploying infrastructure..."
terraform apply -auto-approve

# Wait for ArgoCD to be ready
echo "⏳ Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Get ArgoCD admin password
echo "🔐 Getting ArgoCD admin password..."
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)

# Display access information
echo ""
echo "🎉 StackAI Infrastructure deployed successfully!"
echo ""
echo "📊 Access Information:"
echo "====================="
echo ""
echo "🔧 ArgoCD (GitOps):"
echo "   URL: http://argocd.localhost"
echo "   Username: admin"
echo "   Password: $ARGOCD_PASSWORD"
echo ""
echo "🗄️  Supabase Studio:"
echo "   URL: http://localhost:8000/supabase/studio"
echo "   Username: supabase"
echo "   Password: stackai-dev-studio-password"
echo ""
echo "⚡ Temporal Web UI:"
echo "   URL: http://localhost:8080/temporal"
echo ""
echo "🗃️  Data Stores:"
echo "   MongoDB: mongodb://admin:stackai-dev-password@localhost:27017/admin"
echo "   Redis: redis://localhost:6379"
echo "   PostgreSQL: postgresql://temporal:temporal-dev-password@localhost:5432/temporal"
echo "   Weaviate: http://localhost:8080"
echo ""
echo "🔍 Useful Commands:"
echo "   kubectl get pods -A                    # Check all pods"
echo "   kubectl get svc -A                     # Check all services"
echo "   kubectl port-forward svc/argocd-server -n argocd 8080:80  # Port forward ArgoCD"
echo ""
echo "📚 For more information, see README.md"
