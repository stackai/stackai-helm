#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Function to test infrastructure deployment
test_infrastructure() {
    local environment="${1:-dev}"

    print_status "Testing StackAI infrastructure deployment for $environment environment..."

    # Test namespaces
    print_status "Testing namespaces..."
    for ns in mongodb redis weaviate supabase nginx-ingress; do
        if kubectl get namespace "$ns" &> /dev/null; then
            print_success "Namespace $ns exists"
        else
            print_error "Namespace $ns does not exist"
            return 1
        fi
    done

    # Test pods
    print_status "Testing pods..."
    for ns in mongodb redis weaviate supabase nginx-ingress; do
        echo "--- Testing $ns namespace ---"
        pods=$(kubectl get pods -n "$ns" --no-headers 2>/dev/null | wc -l)
        if [ "$pods" -gt 0 ]; then
            print_success "Found $pods pod(s) in $ns namespace"
            # Check if pods are ready
            ready_pods=$(kubectl get pods -n "$ns" --no-headers 2>/dev/null | grep -c "Running\|Completed" || echo "0")
            if [ "$ready_pods" -gt 0 ]; then
                print_success "$ready_pods pod(s) are ready in $ns namespace"
            else
                print_warning "No ready pods found in $ns namespace"
            fi
        else
            print_warning "No pods found in $ns namespace"
        fi
    done

    # Test services
    print_status "Testing services..."
    for ns in mongodb redis weaviate supabase nginx-ingress; do
        echo "--- Testing $ns namespace ---"
        services=$(kubectl get svc -n "$ns" --no-headers 2>/dev/null | wc -l)
        if [ "$services" -gt 0 ]; then
            print_success "Found $services service(s) in $ns namespace"
        else
            print_warning "No services found in $ns namespace"
        fi
    done

    # Test Helm releases
    print_status "Testing Helm releases..."
    helm_releases=$(helm list -A --no-headers | wc -l)
    if [ "$helm_releases" -gt 0 ]; then
        print_success "Found $helm_releases Helm release(s)"
        helm list -A
    else
        print_warning "No Helm releases found"
    fi

    # Test LoadBalancer IP
    print_status "Testing LoadBalancer..."
    lb_ip=$(kubectl get svc nginx-ingress-controller -n nginx-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "")
    if [ -n "$lb_ip" ] && [ "$lb_ip" != "pending" ]; then
        print_success "LoadBalancer IP assigned: $lb_ip"

        # Test basic connectivity
        print_status "Testing basic connectivity..."
        if curl -s --connect-timeout 5 "http://$lb_ip/" > /dev/null; then
            print_success "Infrastructure is accessible via LoadBalancer"
        else
            print_warning "Infrastructure not accessible via LoadBalancer (may still be starting)"
        fi
    else
        print_warning "LoadBalancer IP not assigned yet"
    fi

    # Test cross-namespace connectivity
    print_status "Testing cross-namespace connectivity..."
    if kubectl run test-connectivity --image=busybox --rm -it --restart=Never -n nginx-ingress -- nslookup supabase-kong.supabase > /dev/null 2>&1; then
        print_success "Cross-namespace DNS resolution working"
    else
        print_warning "Cross-namespace DNS resolution may not be working"
    fi

    print_success "Infrastructure test completed!"
}

# Function to show test results summary
show_test_summary() {
    print_status "Test Results Summary:"

    echo ""
    echo "=== Namespace Status ==="
    kubectl get namespaces -l app=stackai-infra

    echo ""
    echo "=== Pod Status ==="
    for ns in mongodb redis weaviate supabase nginx-ingress; do
        echo "--- $ns namespace ---"
        kubectl get pods -n "$ns" 2>/dev/null || echo "No pods found"
    done

    echo ""
    echo "=== Service Status ==="
    for ns in mongodb redis weaviate supabase nginx-ingress; do
        echo "--- $ns namespace ---"
        kubectl get svc -n "$ns" 2>/dev/null || echo "No services found"
    done

    echo ""
    echo "=== Helm Releases ==="
    helm list -A
}

# Function to show help
show_help() {
    echo "StackAI Infrastructure Test Script"
    echo ""
    echo "Usage: $0 [ENVIRONMENT]"
    echo ""
    echo "Environments:"
    echo "  dev       Test development environment (default)"
    echo "  prod      Test production environment"
    echo ""
    echo "Examples:"
    echo "  $0 dev     # Test development environment"
    echo "  $0 prod    # Test production environment"
}

# Parse command line arguments
ENVIRONMENT="${1:-dev}"

# Validate environment
if [[ "$ENVIRONMENT" != "dev" && "$ENVIRONMENT" != "prod" ]]; then
    print_error "Invalid environment: $ENVIRONMENT. Must be 'dev' or 'prod'"
    show_help
    exit 1
fi

# Run tests
test_infrastructure "$ENVIRONMENT"
show_test_summary
