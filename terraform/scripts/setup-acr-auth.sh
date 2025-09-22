#!/bin/bash

# Setup Azure Container Registry authentication for Kubernetes
set -e

echo "🔐 Setting up Azure Container Registry authentication..."

# Check if required tools are installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI is not installed. Please install Azure CLI first:"
    echo "   https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed. Please install kubectl first"
    exit 1
fi

# Check if user is logged in to Azure
if ! az account show &> /dev/null; then
    echo "🔑 Please log in to Azure first:"
    echo "   az login"
    exit 1
fi

# Get ACR details
ACR_NAME="stackai"
ACR_LOGIN_SERVER="stackai.azurecr.io"

echo "📋 ACR Details:"
echo "   Registry: $ACR_LOGIN_SERVER"
echo "   Name: $ACR_NAME"

# Get ACR credentials
echo "🔑 Getting ACR credentials..."
ACR_USERNAME=$(az acr credential show --name $ACR_NAME --query "username" -o tsv)
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --query "passwords[0].value" -o tsv)

if [ -z "$ACR_USERNAME" ] || [ -z "$ACR_PASSWORD" ]; then
    echo "❌ Failed to get ACR credentials. Please check:"
    echo "   1. You have access to the ACR registry"
    echo "   2. The registry name is correct: $ACR_NAME"
    echo "   3. You have the 'AcrPull' or 'AcrPush' role on the registry"
    exit 1
fi

# Create Kubernetes secret for ACR
echo "🔧 Creating Kubernetes secret for ACR authentication..."
kubectl create secret docker-registry acr-secret \
    --docker-server=$ACR_LOGIN_SERVER \
    --docker-username=$ACR_USERNAME \
    --docker-password=$ACR_PASSWORD \
    --namespace=stackai-processing \
    --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret docker-registry acr-secret \
    --docker-server=$ACR_LOGIN_SERVER \
    --docker-username=$ACR_USERNAME \
    --docker-password=$ACR_PASSWORD \
    --namespace=stackai-infra \
    --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret docker-registry acr-secret \
    --docker-server=$ACR_LOGIN_SERVER \
    --docker-username=$ACR_USERNAME \
    --docker-password=$ACR_PASSWORD \
    --namespace=stackai-data \
    --dry-run=client -o yaml | kubectl apply -f -

echo "✅ ACR authentication secret created successfully!"
echo ""
echo "📊 Secret details:"
kubectl get secret acr-secret -n stackai-processing
kubectl get secret acr-secret -n stackai-infra
kubectl get secret acr-secret -n stackai-data

echo ""
echo "🎉 ACR authentication setup complete!"
echo "   You can now deploy your applications that use private ACR images."
