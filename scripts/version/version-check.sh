#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Version configuration
TARGET_CHART_VERSION="1.0.0"
TARGET_APP_VERSION="1.0.0"

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

# Function to check Helm chart versions
check_chart_version() {
    local chart_file="$1"
    local chart_name=$(basename $(dirname "$chart_file"))

    if [[ ! -f "$chart_file" ]]; then
        print_error "Chart file not found: $chart_file"
        return 1
    fi

    # Extract version and appVersion from Chart.yaml
    local chart_version=$(grep "^version:" "$chart_file" | sed 's/version: *//' | tr -d ' ')
    local app_version=$(grep "^appVersion:" "$chart_file" | sed 's/appVersion: *//' | tr -d ' ')

    # Check chart version
    if [[ "$chart_version" == "$TARGET_CHART_VERSION" ]]; then
        print_success "$chart_name: Chart version ✓ ($chart_version)"
    else
        print_error "$chart_name: Chart version ✗ (expected: $TARGET_CHART_VERSION, found: $chart_version)"
        return 1
    fi

    # Check app version
    if [[ "$app_version" == "$TARGET_APP_VERSION" ]]; then
        print_success "$chart_name: App version ✓ ($app_version)"
    else
        print_error "$chart_name: App version ✗ (expected: $TARGET_APP_VERSION, found: $app_version)"
        return 1
    fi

    return 0
}

# Function to update chart versions
update_chart_version() {
    local chart_file="$1"
    local chart_name=$(basename $(dirname "$chart_file"))

    if [[ ! -f "$chart_file" ]]; then
        print_error "Chart file not found: $chart_file"
        return 1
    fi

    # Update version
    sed -i.bak "s/^version:.*/version: $TARGET_CHART_VERSION/" "$chart_file"
    # Update appVersion
    sed -i.bak "s/^appVersion:.*/appVersion: $TARGET_APP_VERSION/" "$chart_file"

    # Remove backup file
    rm -f "${chart_file}.bak"

    print_success "$chart_name: Updated to version $TARGET_CHART_VERSION, appVersion $TARGET_APP_VERSION"
}

# Function to find all Chart.yaml files
find_chart_files() {
    local base_dir="${1:-.}"
    find "$base_dir" -name "Chart.yaml" -type f | sort
}

# Function to show help
show_help() {
    echo "StackAI Helm Version Check Script"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  check     Check all chart versions (default)"
    echo "  update    Update all chart versions"
    echo "  list      List all chart files"
    echo "  help      Show this help message"
    echo ""
    echo "Options:"
    echo "  --target-chart-version VERSION    Target chart version (default: $TARGET_CHART_VERSION)"
    echo "  --target-app-version VERSION      Target app version (default: $TARGET_APP_VERSION)"
    echo "  --directory DIR                   Directory to search (default: .)"
    echo ""
    echo "Examples:"
    echo "  $0 check"
    echo "  $0 update"
    echo "  $0 check --target-chart-version 1.1.0"
    echo "  $0 update --directory helm/"
}

# Parse command line arguments
COMMAND="check"
DIRECTORY="."

while [[ $# -gt 0 ]]; do
    case $1 in
        check|update|list|help)
            COMMAND="$1"
            shift
            ;;
        --target-chart-version)
            TARGET_CHART_VERSION="$2"
            shift 2
            ;;
        --target-app-version)
            TARGET_APP_VERSION="$2"
            shift 2
            ;;
        --directory)
            DIRECTORY="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Main execution
case $COMMAND in
    check)
        print_status "Checking Helm chart versions..."
        print_status "Target chart version: $TARGET_CHART_VERSION"
        print_status "Target app version: $TARGET_APP_VERSION"
        echo ""

        failed_charts=()
        total_charts=0

        while IFS= read -r chart_file; do
            ((total_charts++))
            if ! check_chart_version "$chart_file"; then
                failed_charts+=("$chart_file")
            fi
        done < <(find_chart_files "$DIRECTORY")

        echo ""
        if [[ ${#failed_charts[@]} -eq 0 ]]; then
            print_success "All $total_charts charts have correct versions!"
        else
            print_error "Found ${#failed_charts[@]} charts with incorrect versions:"
            for chart in "${failed_charts[@]}"; do
                echo "  - $chart"
            done
            exit 1
        fi
        ;;

    update)
        print_status "Updating Helm chart versions..."
        print_status "Target chart version: $TARGET_CHART_VERSION"
        print_status "Target app version: $TARGET_APP_VERSION"
        echo ""

        updated_charts=0

        while IFS= read -r chart_file; do
            update_chart_version "$chart_file"
            ((updated_charts++))
        done < <(find_chart_files "$DIRECTORY")

        echo ""
        print_success "Updated $updated_charts charts!"
        ;;

    list)
        print_status "Listing all Chart.yaml files:"
        while IFS= read -r chart_file; do
            echo "  - $chart_file"
        done < <(find_chart_files "$DIRECTORY")
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
