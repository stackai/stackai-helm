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

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Test the release process locally
print_status "Testing Helm chart packaging and indexing..."

# Create packages directory
mkdir -p .cr-release-packages
print_success "Created packages directory"

# Package infrastructure charts
print_status "Packaging infrastructure charts..."
for chart in mongo redis weviate supabase nginx; do
    if [ -d "helm/infra/$chart" ]; then
        print_status "Packaging helm/infra/$chart"
        helm package helm/infra/$chart --destination .cr-release-packages
        print_success "Packaged $chart"
    else
        print_error "Chart directory not found: helm/infra/$chart"
    fi
done

# Package application charts
print_status "Packaging application charts..."
for chart in stackend stackweb celery repl; do
    if [ -d "helm/app/$chart" ]; then
        print_status "Packaging helm/app/$chart"
        helm package helm/app/$chart --destination .cr-release-packages
        print_success "Packaged $chart"
    else
        print_error "Chart directory not found: helm/app/$chart"
    fi
done

# List packaged files
print_status "Packaged files:"
ls -la .cr-release-packages/

# Create index
print_status "Creating Helm repository index..."
helm repo index .cr-release-packages --url https://stackai.github.io/stackai-helm/

# Check if index was created
if [ -f ".cr-release-packages/index.yaml" ]; then
    print_success "Index file created successfully"
    echo "Index file contents:"
    head -20 .cr-release-packages/index.yaml
else
    print_error "Index file not created"
    exit 1
fi

print_success "Release process test completed successfully!"
