#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_test() {
    echo -e "${BLUE}🧪 Testing: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

echo "🧪 Testing Stackend Deployment..."

# Test 1: Check if pod is running
print_test "Pod Status"
if kubectl get pods -n stackai-app | grep -q "Running"; then
    print_success "Stackend pod is running"
else
    print_error "Stackend pod is not running"
    kubectl get pods -n stackai-app
fi

# Test 2: Check service
print_test "Service Status"
kubectl get svc -n stackai-app

# Test 3: Test health endpoint (internal)
print_test "Internal Health Check"
if kubectl run test-health --rm -i --restart=Never --image=curlimages/curl -- \
   curl -f http://stackend-test.stackai-app.svc.cluster.local:8000/health; then
    print_success "Internal health check passed"
else
    print_error "Internal health check failed"
fi

# Test 4: Show logs
print_test "Recent Logs"
kubectl logs --tail=20 deployment/stackend-test -n stackai-app

echo ""
echo "🎯 Next Steps:"
echo "1. Run './port-forward-stackend.sh' in another terminal"
echo "2. Test: curl http://localhost:9000/health"
echo "3. Check logs: kubectl logs -f deployment/stackend-test -n stackai-app"

