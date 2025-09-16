#!/bin/bash

# Test script for StackAI BYOC Helm Chart
# This script validates the Helm chart without deploying it

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if helm is available
if ! command -v helm &> /dev/null; then
    print_error "helm is not installed or not in PATH"
    exit 1
fi

print_status "Testing StackAI BYOC Helm Chart..."

# Test chart template rendering
print_status "Testing chart template rendering..."
helm template stackai-test ../../helm \
  --values values-local.yaml \
  --debug > /tmp/stackai-test-output.yaml

if [ $? -eq 0 ]; then
    print_status "Chart template rendering successful!"
else
    print_error "Chart template rendering failed!"
    exit 1
fi

# Test chart validation
print_status "Testing chart validation..."
helm lint ../../helm --values values-local.yaml

if [ $? -eq 0 ]; then
    print_status "Chart validation successful!"
else
    print_error "Chart validation failed!"
    exit 1
fi

# Check for common issues
print_status "Checking for common issues..."

# Check if Azure images are properly configured
if grep -q "stackai.azurecr.io" /tmp/stackai-test-output.yaml; then
    print_status "✓ Azure images found (stackend, stackweb, celery)"
else
    print_warning "⚠ No Azure images found - this might be expected for local testing"
fi

# Check if public images are used for infrastructure
if grep -q "postgres:" /tmp/stackai-test-output.yaml; then
    print_status "✓ Public PostgreSQL image found"
fi

if grep -q "supabase/" /tmp/stackai-test-output.yaml; then
    print_status "✓ Public Supabase images found"
fi

if grep -q "weaviate/weaviate:" /tmp/stackai-test-output.yaml; then
    print_status "✓ Public Weaviate image found"
fi

# Check for syntax errors
if grep -q "protocol: TCP" /tmp/stackai-test-output.yaml; then
    print_status "✓ Service protocols look correct"
fi

print_status "Chart testing completed successfully!"
print_status "You can now run ./deploy-local.sh to deploy the chart locally"

# Clean up
rm -f /tmp/stackai-test-output.yaml
