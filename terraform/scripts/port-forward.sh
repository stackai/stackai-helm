#!/bin/bash

# Port forwarding script for StackAI services
set -e

echo "🔌 Setting up port forwarding for StackAI services..."

# Function to start port forwarding in background
start_port_forward() {
    local service=$1
    local namespace=$2
    local local_port=$3
    local service_port=$4
    local description=$5

    echo "Starting port forward for $description..."
    kubectl port-forward "svc/$service" -n "$namespace" "$local_port:$service_port" &
    echo "✅ $description available at localhost:$local_port"
}

# Check if services exist before port forwarding
check_service() {
    local service=$1
    local namespace=$2

    if kubectl get svc "$service" -n "$namespace" &> /dev/null; then
        return 0
    else
        echo "⚠️  Service $service not found in namespace $namespace"
        return 1
    fi
}

echo "🔍 Checking services..."

# ArgoCD
if check_service "argocd-server" "argocd"; then
    start_port_forward "argocd-server" "argocd" "8080" "80" "ArgoCD"
fi

# Supabase Kong
if check_service "supabase-kong" "stackai-infra"; then
    start_port_forward "supabase-kong" "stackai-infra" "8000" "8000" "Supabase API & Studio"
fi

# Temporal Web
if check_service "temporal-web" "stackai-processing"; then
    start_port_forward "temporal-web" "stackai-processing" "8080" "8080" "Temporal Web UI"
fi

# MongoDB
if check_service "mongodb" "stackai-data"; then
    start_port_forward "mongodb" "stackai-data" "27017" "27017" "MongoDB"
fi

# Redis
if check_service "redis" "stackai-data"; then
    start_port_forward "redis" "stackai-data" "6379" "6379" "Redis"
fi

# PostgreSQL
if check_service "postgres" "stackai-data"; then
    start_port_forward "postgres" "stackai-data" "5432" "5432" "PostgreSQL"
fi

# Weaviate
if check_service "weaviate" "stackai-data"; then
    start_port_forward "weaviate" "stackai-data" "8080" "8080" "Weaviate"
fi

echo ""
echo "🎉 Port forwarding setup complete!"
echo ""
echo "📊 Services available at:"
echo "========================"
echo "ArgoCD:        http://localhost:8080"
echo "Supabase:      http://localhost:8000"
echo "Temporal Web:  http://localhost:8080/temporal"
echo "MongoDB:       localhost:27017"
echo "Redis:         localhost:6379"
echo "PostgreSQL:    localhost:5432"
echo "Weaviate:      http://localhost:8080"
echo ""
echo "💡 To stop port forwarding, press Ctrl+C"
echo "   Or run: pkill -f 'kubectl port-forward'"

# Wait for user interrupt
trap 'echo ""; echo "🛑 Stopping port forwarding..."; pkill -f "kubectl port-forward"; echo "✅ Port forwarding stopped"; exit 0' INT

# Keep script running
while true; do
    sleep 1
done
