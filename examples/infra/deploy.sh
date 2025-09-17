#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

BASE_PATH="$(dirname "$0")/../.."

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

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."

    if ! command -v helm &> /dev/null; then
        print_error "Helm is not installed. Please install Helm 3.2.0+"
        exit 1
    fi

    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed. Please install kubectl"
        exit 1
    fi

    if ! kubectl cluster-info &> /dev/null; then
        print_error "kubectl is not configured or cluster is not accessible"
        exit 1
    fi

    print_success "Prerequisites check passed"
}

# Function to deploy infrastructure components
deploy_infrastructure() {
    local environment="${1:-dev}"

    print_status "Deploying StackAI infrastructure components for $environment environment..."

    # Validate environment
    if [[ "$environment" != "dev" && "$environment" != "prod" ]]; then
        print_error "Invalid environment: $environment. Must be 'dev' or 'prod'"
        exit 1
    fi

    # Set values file suffix based on environment
    local values_suffix=""
    if [[ "$environment" == "dev" ]]; then
        values_suffix="local"
    else
        values_suffix="production"
    fi

    # Apply namespaces and nginx configuration first
    print_status "Creating namespaces and Nginx configuration..."
    kubectl apply -f "$(dirname "$0")/deploy-infrastructure.yaml"

    # Deploy MongoDB
    print_status "Deploying MongoDB..."
    helm upgrade --install mongodb "$BASE_PATH/helm/infra/mongo" \
        --namespace mongodb \
        --values "$(dirname "$0")/../values/$environment/mongo-$values_suffix.yaml" \
        --wait --timeout=10m

    # Deploy Redis
    print_status "Deploying Redis..."
    helm upgrade --install redis "$BASE_PATH/helm/infra/redis" \
        --namespace redis \
        --values "$(dirname "$0")/../values/$environment/redis-$values_suffix.yaml" \
        --wait --timeout=10m

    # Deploy Weaviate
    print_status "Deploying Weaviate..."
    helm upgrade --install weaviate "$BASE_PATH/helm/infra/weviate" \
        --namespace weaviate \
        --values "$(dirname "$0")/../values/$environment/weaviate-$values_suffix.yaml" \
        --wait --timeout=10m

    # Deploy Supabase
    print_status "Deploying Supabase..."
    helm upgrade --install supabase "$BASE_PATH/helm/infra/supabase" \
        --namespace supabase \
        --values "$(dirname "$0")/../values/$environment/supabase-$values_suffix.yaml" \
        --wait --timeout=15m

    # Deploy Nginx Ingress Controller
    print_status "Deploying Nginx Ingress Controller..."
    helm upgrade --install nginx-ingress "$BASE_PATH/helm/infra/nginx" \
        --namespace nginx-ingress \
        --set controller.service.type=LoadBalancer \
        --set controller.replicaCount=1 \
        --set controller.resources.requests.memory=128Mi \
        --set controller.resources.requests.cpu=100m \
        --set controller.resources.limits.memory=256Mi \
        --set controller.resources.limits.cpu=200m \
        --set defaultBackend.enabled=true \
        --set rbac.create=true \
        --wait --timeout=10m

    print_success "Infrastructure components deployed successfully for $environment environment!"
}

# Function to get service URLs
get_service_urls() {
    print_status "Getting service URLs..."

    echo ""
    echo "=== Service URLs ==="

    # Get LoadBalancer IP
    local lb_ip=$(kubectl get svc nginx-ingress-controller -n nginx-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "pending")

    if [ "$lb_ip" != "pending" ] && [ -n "$lb_ip" ]; then
        echo "🌐 Infrastructure Status: http://$lb_ip"
        echo "🗄️  Supabase Studio: http://$lb_ip/studio/"
        echo "📊 Supabase API: http://$lb_ip/rest/v1/"
        echo "🔐 Auth API: http://$lb_ip/auth/v1/"
        echo "⚡ Realtime: ws://$lb_ip/realtime/v1/"
        echo "🚀 Functions: http://$lb_ip/functions/v1/"
        echo "📈 Analytics: http://$lb_ip/analytics/v1/"
        echo "🔑 SSO: http://$lb_ip/sso/"
    else
        echo "⏳ LoadBalancer IP is still being assigned..."
        echo "Run 'kubectl get svc -n nginx-ingress' to check status"
    fi

    echo ""
    echo "=== Port Forward Commands (for local access) ==="
    echo "kubectl port-forward -n nginx-ingress svc/nginx-ingress-controller 8080:80"
    echo "kubectl port-forward -n supabase svc/supabase-kong 8001:8000"
    echo "kubectl port-forward -n supabase svc/supabase-studio 3001:3000"
    echo "kubectl port-forward -n mongodb svc/mongodb 27017:27017"
    echo "kubectl port-forward -n redis svc/redis 6379:6379"
    echo "kubectl port-forward -n weaviate svc/weaviate 8081:8080"

    echo ""
    echo "=== Service Endpoints ==="
    echo "MongoDB: mongodb.mongodb.svc.cluster.local:27017"
    echo "Redis: redis.redis.svc.cluster.local:6379"
    echo "Weaviate: weaviate.weaviate.svc.cluster.local:8080"
    echo "Supabase Kong: supabase-kong.supabase.svc.cluster.local:8000"
    echo "Supabase Studio: supabase-studio.supabase.svc.cluster.local:3000"
}

# Function to show deployment status
show_status() {
    print_status "Deployment Status:"

    echo ""
    echo "=== Namespaces ==="
    kubectl get namespaces -l app=stackai-infra

    echo ""
    echo "=== Helm Releases ==="
    helm list -A

    echo ""
    echo "=== Pods Status ==="
    for ns in mongodb redis weaviate supabase nginx-ingress; do
        echo "--- $ns namespace ---"
        kubectl get pods -n "$ns" 2>/dev/null || echo "No pods in $ns namespace"
    done

    echo ""
    echo "=== Services ==="
    for ns in mongodb redis weaviate supabase nginx-ingress; do
        echo "--- $ns namespace ---"
        kubectl get svc -n "$ns" 2>/dev/null || echo "No services in $ns namespace"
    done
}

# Function to cleanup
cleanup() {
    print_warning "Cleaning up StackAI infrastructure deployment..."

    # Uninstall Helm releases
    helm uninstall nginx-ingress -n nginx-ingress 2>/dev/null || true
    helm uninstall supabase -n supabase 2>/dev/null || true
    helm uninstall weaviate -n weaviate 2>/dev/null || true
    helm uninstall redis -n redis 2>/dev/null || true
    helm uninstall mongodb -n mongodb 2>/dev/null || true

    # Delete namespaces (this will clean up all resources)
    kubectl delete namespace nginx-ingress 2>/dev/null || true
    kubectl delete namespace supabase 2>/dev/null || true
    kubectl delete namespace weaviate 2>/dev/null || true
    kubectl delete namespace redis 2>/dev/null || true
    kubectl delete namespace mongodb 2>/dev/null || true

    print_success "Cleanup completed"
}

# Function to show help
show_help() {
    echo "StackAI Infrastructure Deployment Script"
    echo ""
    echo "Usage: $0 [COMMAND] [ENVIRONMENT]"
    echo ""
    echo "Commands:"
    echo "  deploy    Deploy all infrastructure components (default)"
    echo "  status    Show deployment status"
    echo "  urls      Get service URLs"
    echo "  cleanup   Remove all deployments"
    echo "  help      Show this help message"
    echo ""
    echo "Environments:"
    echo "  dev       Development environment (default)"
    echo "  prod      Production environment"
    echo ""
    echo "Examples:"
    echo "  $0 deploy dev     # Deploy development environment"
    echo "  $0 deploy prod    # Deploy production environment"
    echo "  $0 status         # Show deployment status"
    echo "  $0 cleanup        # Remove all deployments"
}

# Parse command line arguments
COMMAND="${1:-deploy}"
ENVIRONMENT="${2:-dev}"

case $COMMAND in
    deploy)
        check_prerequisites
        deploy_infrastructure "$ENVIRONMENT"
        get_service_urls
        ;;
    status)
        show_status
        ;;
    urls)
        get_service_urls
        ;;
    cleanup)
        cleanup
        ;;
    help)
        show_help
        ;;
    *)
        print_error "Unknown command: $COMMAND"
        show_help
        exit 1
        ;;
esac

print_success "Operation completed successfully!"
