#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
CONFIG_FILE="scripts/version-config.yaml"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

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

print_header() {
    echo -e "${CYAN}$1${NC}"
}

# Function to check if yq is installed
check_yq() {
    if ! command -v yq &> /dev/null; then
        print_error "yq is required but not installed. Please install yq:"
        echo "  brew install yq"
        echo "  or visit: https://github.com/mikefarah/yq"
        exit 1
    fi
}

# Function to get version from config
get_version() {
    local path="$1"
    yq eval "$path" "$CONFIG_FILE"
}

# Function to get all chart files
get_chart_files() {
    find "$PROJECT_ROOT" -name "Chart.yaml" -type f | sort
}

# Function to get chart info
get_chart_info() {
    local chart_file="$1"
    local chart_dir=$(dirname "$chart_file")
    local chart_name=$(basename "$chart_dir")
    local chart_path=$(echo "$chart_dir" | sed "s|$PROJECT_ROOT/||")

    # Determine category
    local category="unknown"
    if [[ "$chart_path" == "helm/infra"* ]]; then
        category="infrastructure"
    elif [[ "$chart_path" == "helm/app"* ]]; then
        category="application"
    fi

    echo "$chart_name|$chart_path|$category"
}

# Function to check chart version
check_chart_version() {
    local chart_file="$1"
    local chart_info=$(get_chart_info "$chart_file")
    IFS='|' read -r chart_name chart_path category <<< "$chart_info"

    if [[ ! -f "$chart_file" ]]; then
        print_error "Chart file not found: $chart_file"
        return 1
    fi

    # Get current versions
    local current_chart_version=$(grep "^version:" "$chart_file" | sed 's/version: *//' | tr -d ' ')
    local current_app_version=$(grep "^appVersion:" "$chart_file" | sed 's/appVersion: *//' | tr -d ' ')

    # Get expected versions from config
    local expected_chart_version=$(get_version ".${category}.chartVersion")
    local expected_app_version=$(get_version ".${category}.components.${chart_name}.appVersion // .${category}.appVersion")

    # Display chart info
    echo -e "${CYAN}📦 $chart_name${NC} ($category)"
    echo "  Path: $chart_path"
    echo "  Chart Version: $current_chart_version $(if [[ "$current_chart_version" == "$expected_chart_version" ]]; then echo "✅"; else echo "❌ (expected: $expected_chart_version)"; fi)"
    echo "  App Version: $current_app_version $(if [[ "$current_app_version" == "$expected_app_version" ]]; then echo "✅"; else echo "❌ (expected: $expected_app_version)"; fi)"
    echo ""

    # Return status
    if [[ "$current_chart_version" == "$expected_chart_version" && "$current_app_version" == "$expected_app_version" ]]; then
        return 0
    else
        return 1
    fi
}

# Function to update chart version
update_chart_version() {
    local chart_file="$1"
    local chart_info=$(get_chart_info "$chart_file")
    IFS='|' read -r chart_name chart_path category <<< "$chart_info"

    if [[ ! -f "$chart_file" ]]; then
        print_error "Chart file not found: $chart_file"
        return 1
    fi

    # Get expected versions from config
    local expected_chart_version=$(get_version ".${category}.chartVersion")
    local expected_app_version=$(get_version ".${category}.components.${chart_name}.appVersion // .${category}.appVersion")

    # Update version
    sed -i.bak "s/^version:.*/version: $expected_chart_version/" "$chart_file"
    # Update appVersion
    sed -i.bak "s/^appVersion:.*/appVersion: $expected_app_version/" "$chart_file"

    # Remove backup file
    rm -f "${chart_file}.bak"

    print_success "$chart_name: Updated to version $expected_chart_version, appVersion $expected_app_version"
}

# Function to show version summary
show_version_summary() {
    print_header "📋 StackAI Helm Charts Version Summary"
    echo ""

    local total_charts=0
    local correct_charts=0

    while IFS= read -r chart_file; do
        ((total_charts++))
        if check_chart_version "$chart_file"; then
            ((correct_charts++))
        fi
    done < <(get_chart_files)

    echo ""
    print_header "📊 Summary"
    echo "Total charts: $total_charts"
    echo "Correct versions: $correct_charts"
    echo "Incorrect versions: $((total_charts - correct_charts))"

    if [[ $correct_charts -eq $total_charts ]]; then
        print_success "All charts have correct versions! 🎉"
        return 0
    else
        print_error "Some charts need version updates"
        return 1
    fi
}

# Function to bump versions
bump_version() {
    local bump_type="$1"
    local component="$2"

    print_status "Bumping $bump_type version for $component..."

    # This would require more complex logic to actually bump versions
    # For now, just show what would be done
    print_warning "Version bumping not yet implemented. Please update version-config.yaml manually."
}

# Function to show help
show_help() {
    echo "StackAI Helm Version Manager"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  check     Check all chart versions against config"
    echo "  update    Update all chart versions from config"
    echo "  summary   Show detailed version summary"
    echo "  list      List all chart files"
    echo "  config    Show current version configuration"
    echo "  bump      Bump versions (patch|minor|major)"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 check"
    echo "  $0 update"
    echo "  $0 summary"
    echo "  $0 config"
    echo "  $0 bump patch"
}

# Function to show config
show_config() {
    print_header "📋 Current Version Configuration"
    echo ""
    if [[ -f "$CONFIG_FILE" ]]; then
        cat "$CONFIG_FILE"
    else
        print_error "Configuration file not found: $CONFIG_FILE"
        exit 1
    fi
}

# Main execution
COMMAND="${1:-check}"

case $COMMAND in
    check)
        check_yq
        print_header "🔍 Checking Helm Chart Versions"
        echo ""

        local failed_charts=()
        local total_charts=0

        while IFS= read -r chart_file; do
            ((total_charts++))
            if ! check_chart_version "$chart_file"; then
                failed_charts+=("$chart_file")
            fi
        done < <(get_chart_files)

        if [[ ${#failed_charts[@]} -eq 0 ]]; then
            print_success "All $total_charts charts have correct versions!"
        else
            print_error "Found ${#failed_charts[@]} charts with incorrect versions"
            exit 1
        fi
        ;;

    update)
        check_yq
        print_header "🔄 Updating Helm Chart Versions"
        echo ""

        local updated_charts=0

        while IFS= read -r chart_file; do
            update_chart_version "$chart_file"
            ((updated_charts++))
        done < <(get_chart_files)

        print_success "Updated $updated_charts charts!"
        ;;

    summary)
        check_yq
        show_version_summary
        ;;

    list)
        print_header "📁 Helm Chart Files"
        echo ""
        while IFS= read -r chart_file; do
            echo "  - $chart_file"
        done < <(get_chart_files)
        ;;

    config)
        show_config
        ;;

    bump)
        bump_type="${2:-patch}"
        component="${3:-all}"
        bump_version "$bump_type" "$component"
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
