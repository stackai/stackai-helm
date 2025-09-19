#!/bin/bash

# Status check script for StackAI services
set -e

echo "📊 StackAI Infrastructure Status"
echo "==============================="
echo ""

# Function to check service status
check_service() {
    local service=$1
    local namespace=$2
    local description=$3

    if kubectl get svc "$service" -n "$namespace" &> /dev/null; then
        local status=$(kubectl get svc "$service" -n "$namespace" -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
        if [ -n "$status" ]; then
            echo "✅ $description: Ready (External IP: $status)"
        else
            echo "🟡 $description: Running (ClusterIP)"
        fi
    else
        echo "❌ $description: Not found"
    fi
}

# Function to check deployment status
check_deployment() {
    local deployment=$1
    local namespace=$2
    local description=$3

    if kubectl get deployment "$deployment" -n "$namespace" &> /dev/null; then
        local ready=$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.status.readyReplicas}')
        local desired=$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.status.replicas}')

        if [ "$ready" = "$desired" ] && [ -n "$ready" ]; then
            echo "✅ $description: Ready ($ready/$desired pods)"
        else
            echo "🟡 $description: Starting ($ready/$desired pods ready)"
        fi
    else
        echo "❌ $description: Not found"
    fi
}

# Check namespaces
echo "📁 Namespaces:"
echo "--------------"
kubectl get namespaces | grep -E "(argocd|stackai)" || echo "No StackAI namespaces found"

echo ""
echo "🚀 Deployments:"
echo "---------------"

# ArgoCD
check_deployment "argocd-server" "argocd" "ArgoCD Server"
check_deployment "argocd-application-controller" "argocd" "ArgoCD Controller"

# Infrastructure
check_deployment "nginx-ingress-controller" "stackai-infra" "Nginx Ingress"
check_deployment "supabase-kong" "stackai-infra" "Supabase Kong"
check_deployment "supabase-auth" "stackai-infra" "Supabase Auth"
check_deployment "supabase-db" "stackai-infra" "Supabase DB"
check_deployment "supabase-rest" "stackai-infra" "Supabase REST"
check_deployment "supabase-realtime" "stackai-infra" "Supabase Realtime"
check_deployment "supabase-functions" "stackai-infra" "Supabase Functions"
check_deployment "supabase-studio" "stackai-infra" "Supabase Studio"

# Data stores
check_deployment "mongodb" "stackai-data" "MongoDB"
check_deployment "redis" "stackai-data" "Redis"
check_deployment "postgres" "stackai-data" "PostgreSQL"
check_deployment "weaviate" "stackai-data" "Weaviate"

# Processing
check_deployment "temporal" "stackai-processing" "Temporal Server"
check_deployment "temporal-web" "stackai-processing" "Temporal Web"

echo ""
echo "🌐 Services:"
echo "------------"

# ArgoCD
check_service "argocd-server" "argocd" "ArgoCD Server"

# Infrastructure
check_service "nginx-ingress-controller" "stackai-infra" "Nginx Ingress"
check_service "supabase-kong" "stackai-infra" "Supabase Kong"
check_service "supabase-studio" "stackai-infra" "Supabase Studio"

# Data stores
check_service "mongodb" "stackai-data" "MongoDB"
check_service "redis" "stackai-data" "Redis"
check_service "postgres" "stackai-data" "PostgreSQL"
check_service "weaviate" "stackai-data" "Weaviate"

# Processing
check_service "temporal-web" "stackai-processing" "Temporal Web"

echo ""
echo "📈 Resource Usage:"
echo "------------------"
kubectl top nodes 2>/dev/null || echo "Metrics server not available"

echo ""
echo "🔍 Pod Status:"
echo "-------------"
kubectl get pods -A | grep -E "(argocd|stackai)" | head -20

echo ""
echo "🌍 Ingress:"
echo "-----------"
kubectl get ingress -A 2>/dev/null || echo "No ingress resources found"

echo ""
echo "💡 Access URLs:"
echo "---------------"
echo "ArgoCD:        http://argocd.localhost (or port-forward to localhost:8080)"
echo "Supabase:      http://localhost:8000"
echo "Temporal Web:  http://localhost:8080/temporal"
echo ""

# Check for any failed pods
echo "🚨 Issues:"
echo "----------"
FAILED_PODS=$(kubectl get pods -A --field-selector=status.phase!=Running,status.phase!=Succeeded | grep -v "NAMESPACE" | wc -l)
if [ "$FAILED_PODS" -gt 0 ]; then
    echo "⚠️  Found $FAILED_PODS non-running pods:"
    kubectl get pods -A --field-selector=status.phase!=Running,status.phase!=Succeeded | grep -v "NAMESPACE"
    echo ""
    echo "💡 To troubleshoot:"
    echo "   kubectl describe pod <pod-name> -n <namespace>"
    echo "   kubectl logs <pod-name> -n <namespace>"
else
    echo "✅ All pods are running successfully"
fi
