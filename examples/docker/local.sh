#!/bin/bash

# Docker Compose local testing script for StackAI BYOC
# This script runs the StackAI application locally using Docker Compose

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

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed or not in PATH"
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed or not in PATH"
    exit 1
fi

print_status "Starting local StackAI BYOC with Docker Compose..."

# Check if Azure Container Registry access is configured
print_warning "Make sure you have access to Azure Container Registry (stackai.azurecr.io)"
print_warning "If not, run: az acr login --name stackai.azurecr.io"

# Start the services
print_status "Starting all services..."
docker-compose -f docker-compose.local.yml up -d

# Wait for services to be ready
print_status "Waiting for services to be ready..."
sleep 30

# Check service status
print_status "Checking service status..."
docker-compose -f docker-compose.local.yml ps

# Display access information
print_status "Services started successfully!"
echo ""
print_status "Access Information:"
echo "  - StackWeb (Frontend): http://localhost:3000"
echo "  - StackEnd (Backend API): http://localhost:8000"
echo "  - Nginx Proxy: http://localhost:80"
echo "  - MongoDB: localhost:27017"
echo "  - Redis: localhost:6379"
echo "  - Supabase DB: localhost:5432"
echo "  - Weaviate: http://localhost:8080"
echo ""
print_status "To view logs:"
echo "  docker-compose -f docker-compose.local.yml logs -f stackend"
echo "  docker-compose -f docker-compose.local.yml logs -f stackweb"
echo "  docker-compose -f docker-compose.local.yml logs -f celery"
echo ""
print_status "To stop services:"
echo "  docker-compose -f docker-compose.local.yml down"
echo ""
print_status "To stop and remove volumes:"
echo "  docker-compose -f docker-compose.local.yml down -v"
