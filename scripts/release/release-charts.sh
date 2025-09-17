#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${CYAN}$1${NC}"
}

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

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CHARTS_DIR="$PROJECT_ROOT/helm"
PACKAGES_DIR="$PROJECT_ROOT/.cr-release-packages"
INDEX_FILE="$PROJECT_ROOT/index.yaml"
REPO_URL="https://stackai.github.io/stackai-helm/"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."

    if ! command_exists helm; then
        print_error "Helm is required but not installed"
        exit 1
    fi

    if ! command_exists git; then
        print_error "Git is required but not installed"
        exit 1
    fi

    print_success "Prerequisites check passed"
}

# Function to package a single chart
package_chart() {
    local chart_dir="$1"
    local chart_name=$(basename "$chart_dir")

    if [[ ! -d "$chart_dir" ]]; then
        print_error "Chart directory not found: $chart_dir"
        return 1
    fi

    if [[ ! -f "$chart_dir/Chart.yaml" ]]; then
        print_error "Chart.yaml not found in: $chart_dir"
        return 1
    fi

    print_status "Packaging chart: $chart_name"

    # Create packages directory if it doesn't exist
    mkdir -p "$PACKAGES_DIR"

    # Package the chart
    if helm package "$chart_dir" --destination "$PACKAGES_DIR"; then
        print_success "Successfully packaged: $chart_name"
        return 0
    else
        print_error "Failed to package: $chart_name"
        return 1
    fi
}

# Function to package all charts
package_all_charts() {
    print_header "📦 Packaging All Helm Charts"
    echo ""

    local failed_charts=()
    local total_charts=0

    # Package infrastructure charts
    print_status "Packaging infrastructure charts..."
    for chart_dir in "$CHARTS_DIR/infra"/*; do
        if [[ -d "$chart_dir" ]]; then
            ((total_charts++))
            if ! package_chart "$chart_dir"; then
                failed_charts+=("$(basename "$chart_dir")")
            fi
        fi
    done

    # Package application charts
    print_status "Packaging application charts..."
    for chart_dir in "$CHARTS_DIR/app"/*; do
        if [[ -d "$chart_dir" ]]; then
            ((total_charts++))
            if ! package_chart "$chart_dir"; then
                failed_charts+=("$(basename "$chart_dir")")
            fi
        fi
    done

    echo ""
    if [[ ${#failed_charts[@]} -eq 0 ]]; then
        print_success "Successfully packaged all $total_charts charts!"
    else
        print_error "Failed to package ${#failed_charts[@]} charts:"
        for chart in "${failed_charts[@]}"; do
            echo "  - $chart"
        done
        exit 1
    fi
}

# Function to generate repository index
generate_index() {
    print_status "Generating repository index..."

    if [[ ! -d "$PACKAGES_DIR" ]]; then
        print_error "Packages directory not found: $PACKAGES_DIR"
        return 1
    fi

    # Generate index
    if helm repo index "$PACKAGES_DIR" --url "$REPO_URL"; then
        print_success "Repository index generated successfully"

        # Move index to project root
        if [[ -f "$PACKAGES_DIR/index.yaml" ]]; then
            mv "$PACKAGES_DIR/index.yaml" "$INDEX_FILE"
            print_success "Index file moved to: $INDEX_FILE"
        fi
    else
        print_error "Failed to generate repository index"
        return 1
    fi
}

# Function to validate charts
validate_charts() {
    print_header "🔍 Validating Helm Charts"
    echo ""

    local failed_charts=()
    local total_charts=0

    # Validate infrastructure charts
    print_status "Validating infrastructure charts..."
    for chart_dir in "$CHARTS_DIR/infra"/*; do
        if [[ -d "$chart_dir" ]]; then
            ((total_charts++))
            local chart_name=$(basename "$chart_dir")

            print_status "Validating: $chart_name"

            # Helm lint
            if ! helm lint "$chart_dir"; then
                print_error "$chart_name: Helm lint failed"
                failed_charts+=("$chart_name")
                continue
            fi

            # Template test
            if ! helm template "$chart_name" "$chart_dir" > /dev/null 2>&1; then
                print_error "$chart_name: Template rendering failed"
                failed_charts+=("$chart_name")
                continue
            fi

            print_success "$chart_name: Validation passed"
        fi
    done

    # Validate application charts
    print_status "Validating application charts..."
    for chart_dir in "$CHARTS_DIR/app"/*; do
        if [[ -d "$chart_dir" ]]; then
            ((total_charts++))
            local chart_name=$(basename "$chart_dir")

            print_status "Validating: $chart_name"

            # Helm lint
            if ! helm lint "$chart_dir"; then
                print_error "$chart_name: Helm lint failed"
                failed_charts+=("$chart_name")
                continue
            fi

            # Template test
            if ! helm template "$chart_name" "$chart_dir" > /dev/null 2>&1; then
                print_error "$chart_name: Template rendering failed"
                failed_charts+=("$chart_name")
                continue
            fi

            print_success "$chart_name: Validation passed"
        fi
    done

    echo ""
    if [[ ${#failed_charts[@]} -eq 0 ]]; then
        print_success "All $total_charts charts passed validation!"
    else
        print_error "Validation failed for ${#failed_charts[@]} charts:"
        for chart in "${failed_charts[@]}"; do
            echo "  - $chart"
        done
        exit 1
    fi
}

# Function to show chart information
show_chart_info() {
    local chart_dir="$1"
    local chart_name=$(basename "$chart_dir")

    if [[ -f "$chart_dir/Chart.yaml" ]]; then
        local version=$(grep "^version:" "$chart_dir/Chart.yaml" | sed 's/version: *//' | tr -d ' ')
        local app_version=$(grep "^appVersion:" "$chart_dir/Chart.yaml" | sed 's/appVersion: *//' | tr -d ' ')
        local description=$(grep "^description:" "$chart_dir/Chart.yaml" | sed 's/description: *//' | tr -d ' ')

        echo "  📦 $chart_name"
        echo "     Version: $version"
        echo "     App Version: $app_version"
        echo "     Description: $description"
    fi
}

# Function to list all charts
list_charts() {
    print_header "📋 Available Helm Charts"
    echo ""

    print_status "Infrastructure Charts:"
    for chart_dir in "$CHARTS_DIR/infra"/*; do
        if [[ -d "$chart_dir" ]]; then
            show_chart_info "$chart_dir"
        fi
    done

    echo ""
    print_status "Application Charts:"
    for chart_dir in "$CHARTS_DIR/app"/*; do
        if [[ -d "$chart_dir" ]]; then
            show_chart_info "$chart_dir"
        fi
    done
}

# Function to clean up
cleanup() {
    print_status "Cleaning up..."

    if [[ -d "$PACKAGES_DIR" ]]; then
        rm -rf "$PACKAGES_DIR"
        print_success "Cleaned up packages directory"
    fi

    if [[ -f "$INDEX_FILE" ]]; then
        rm -f "$INDEX_FILE"
        print_success "Cleaned up index file"
    fi
}

# Function to show help
show_help() {
    echo "StackAI Helm Charts Release Script"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  package     Package all charts"
    echo "  validate    Validate all charts"
    echo "  index       Generate repository index"
    echo "  release     Full release process (validate + package + index)"
    echo "  list        List all available charts"
    echo "  clean       Clean up generated files"
    echo "  help        Show this help message"
    echo ""
    echo "Options:"
    echo "  --chart-dir DIR    Specific chart directory to process"
    echo "  --dry-run          Show what would be done without executing"
    echo ""
    echo "Examples:"
    echo "  $0 release                    # Full release process"
    echo "  $0 package                    # Package all charts"
    echo "  $0 validate                   # Validate all charts"
    echo "  $0 list                       # List all charts"
    echo "  $0 clean                      # Clean up files"
}

# Main execution
COMMAND="${1:-help}"

case $COMMAND in
    package)
        check_prerequisites
        package_all_charts
        ;;

    validate)
        check_prerequisites
        validate_charts
        ;;

    index)
        check_prerequisites
        generate_index
        ;;

    release)
        check_prerequisites
        validate_charts
        package_all_charts
        generate_index
        print_success "Release process completed successfully!"
        ;;

    list)
        list_charts
        ;;

    clean)
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
