#!/bin/bash

set -e

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

echo "🚀 Deploying Infrastructure Services..."

# Run the existing infrastructure deployment
print_status "Deploying infrastructure services..."
bash .devcontainer/start-services.sh

print_success "Infrastructure services deployed!"

# Get service URLs
print_status "Getting service URLs..."
bash get-service-urls.sh

print_success "Infrastructure deployment complete!"