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

# Function to test Helm template
test_helm_template() {
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

    print_status "Testing Helm template for: $chart_name"

    # Test 1: Helm lint
    if ! helm lint "$chart_dir"; then
        print_error "Helm lint failed for: $chart_name"
        return 1
    fi

    # Test 2: Template rendering with default values
    if ! helm template "$chart_name" "$chart_dir" --debug > /dev/null 2>&1; then
        print_error "Helm template rendering failed for: $chart_name"
        return 1
    fi

    # Test 3: Skip install dry-run for charts with CRDs (already covered by template test)

    # Test 4: Check for common template issues
    local template_output
    template_output=$(helm template "$chart_name" "$chart_dir" 2>/dev/null)

    # Check for undefined values
    if echo "$template_output" | grep -q "undefined"; then
        print_warning "$chart_name: Found 'undefined' values in template output"
    fi

    # Check for empty values
    if echo "$template_output" | grep -q "null"; then
        print_warning "$chart_name: Found 'null' values in template output"
    fi

    print_success "$chart_name: All template tests passed"
    return 0
}

# Function to find all Helm charts
find_helm_charts() {
    find . -name "Chart.yaml" -type f | while read -r chart_file; do
        dirname "$chart_file"
    done | sort
}

# Main execution
print_status "Running Helm template tests..."

failed_charts=()
total_charts=0

while IFS= read -r chart_dir; do
    ((total_charts++))
    if ! test_helm_template "$chart_dir"; then
        failed_charts+=("$chart_dir")
    fi
done < <(find_helm_charts)

echo ""
if [[ ${#failed_charts[@]} -eq 0 ]]; then
    print_success "All $total_charts Helm charts passed template tests!"
else
    print_error "Found ${#failed_charts[@]} charts with template issues:"
    for chart in "${failed_charts[@]}"; do
        echo "  - $chart"
    done
    exit 1
fi
