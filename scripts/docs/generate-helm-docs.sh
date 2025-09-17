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

# Function to check if helm-docs is installed
check_helm_docs() {
    if ! command -v helm-docs &> /dev/null; then
        print_error "helm-docs is required but not installed. Please install it:"
        echo "  go install github.com/norwoodj/helm-docs/cmd/helm-docs@latest"
        echo "  or visit: https://github.com/norwoodj/helm-docs"
        exit 1
    fi
}

# Function to generate documentation for a Helm chart
generate_chart_docs() {
    local chart_dir="$1"
    local chart_name=$(basename "$chart_dir")

    if [[ ! -d "$chart_dir" ]]; then
        print_error "Chart directory not found: $chart_dir"
        return 1
    fi

    if [[ ! -f "$chart_dir/values.yaml" ]]; then
        print_warning "$chart_name: No values.yaml found, skipping documentation generation"
        return 0
    fi

    print_status "Generating documentation for: $chart_name"

    # Generate documentation
    if helm-docs "$chart_dir"; then
        print_success "$chart_name: Documentation generated successfully"
        return 0
    else
        print_error "$chart_name: Failed to generate documentation"
        return 1
    fi
}

# Function to find all Helm charts
find_helm_charts() {
    find . -name "values.yaml" -type f | while read -r values_file; do
        dirname "$values_file"
    done | sort
}

# Function to generate comprehensive documentation
generate_comprehensive_docs() {
    print_status "Generating comprehensive Helm charts documentation..."

    # Create docs directory if it doesn't exist
    mkdir -p docs/helm

    # Generate main documentation
    cat > docs/helm/README.md << 'EOF'
# StackAI Helm Charts Documentation

This directory contains comprehensive documentation for all StackAI Helm charts.

## Charts Overview

### Infrastructure Charts
- **MongoDB** - Database storage for StackAI applications
- **Redis** - In-memory data store for caching and session management
- **Weaviate** - Vector database for AI/ML applications
- **Supabase** - Backend-as-a-Service platform
- **Nginx Ingress Controller** - Load balancer and ingress controller

### Application Charts
- **Stackend** - StackAI backend API service
- **Stackweb** - StackAI frontend web application
- **Celery** - Background task processing with Redis broker
- **Repl** - StackAI Repl API service

## Quick Start

### Prerequisites
- Kubernetes 1.19+
- Helm 3.2.0+
- External Secrets Operator (for production)
- Azure Key Vault (for production secrets)

### Installation

```bash
# Add StackAI Helm repository (when published)
helm repo add stackai https://charts.stackai.com
helm repo update

# Install infrastructure components
helm install mongodb stackai/stackai-mongodb
helm install redis stackai/stackai-redis
helm install weaviate stackai/stackai-weaviate
helm install supabase stackai/stackai-supabase
helm install nginx stackai/stackai-nginx-ingress

# Install application components
helm install stackend stackai/stackai-stackend
helm install stackweb stackai/stackai-stackweb
helm install celery stackai/stackai-celery
helm install repl stackai/stackai-repl
```

### Development Setup

For local development, use the example configurations:

```bash
# Deploy infrastructure
cd examples/infra
./deploy.sh deploy dev

# Deploy applications
cd examples/app
./deploy.sh deploy dev
```

## Configuration

Each chart can be customized using values files. See individual chart documentation for detailed configuration options.

## Security

All charts implement security best practices:
- Non-root containers
- External secrets management
- TLS termination
- Resource limits
- Security contexts

## Support

For issues and questions:
- GitHub Issues: https://github.com/stackai/stackai-helm/issues
- Documentation: https://docs.stackai.com
- Support: support@stackai.com

EOF

    print_success "Comprehensive documentation generated"
}

# Function to show help
show_help() {
    echo "StackAI Helm Documentation Generator"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  generate    Generate documentation for all charts (default)"
    echo "  chart       Generate documentation for specific chart"
    echo "  comprehensive  Generate comprehensive documentation"
    echo "  help        Show this help message"
    echo ""
    echo "Options:"
    echo "  --chart-dir DIR    Specific chart directory to document"
    echo ""
    echo "Examples:"
    echo "  $0 generate"
    echo "  $0 chart --chart-dir helm/infra/mongo"
    echo "  $0 comprehensive"
}

# Main execution
COMMAND="${1:-generate}"

case $COMMAND in
    generate)
        check_helm_docs
        print_status "Generating Helm chart documentation..."

        failed_charts=()
        total_charts=0

        while IFS= read -r chart_dir; do
            ((total_charts++))
            if ! generate_chart_docs "$chart_dir"; then
                failed_charts+=("$chart_dir")
            fi
        done < <(find_helm_charts)

        echo ""
        if [[ ${#failed_charts[@]} -eq 0 ]]; then
            print_success "Documentation generated for all $total_charts charts!"
        else
            print_error "Failed to generate documentation for ${#failed_charts[@]} charts:"
            for chart in "${failed_charts[@]}"; do
                echo "  - $chart"
            done
            exit 1
        fi
        ;;

    chart)
        chart_dir="$2"
        if [[ -z "$chart_dir" ]]; then
            print_error "Chart directory not specified"
            show_help
            exit 1
        fi

        check_helm_docs
        generate_chart_docs "$chart_dir"
        ;;

    comprehensive)
        generate_comprehensive_docs
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
