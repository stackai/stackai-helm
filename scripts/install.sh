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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install dependencies
install_dependencies() {
    print_header "🚀 StackAI Helm Charts Development Tools Installation"
    echo ""

    print_status "Checking system requirements..."

    # Check if we're in the right directory
    if [[ ! -f "scripts/Makefile" ]]; then
        print_error "Please run this script from the project root directory"
        exit 1
    fi

    # Check Python
    if ! command_exists python3; then
        print_error "Python 3 is required but not installed"
        exit 1
    fi

    # Check Node.js
    if ! command_exists node; then
        print_warning "Node.js not found. Some formatting tools may not work"
    fi

    # Check Go
    if ! command_exists go; then
        print_warning "Go not found. helm-docs may not be available"
    fi

    print_status "Installing Python packages..."
    pip3 install --user pre-commit yamllint

    print_status "Installing Node.js packages..."
    if command_exists npm; then
        npm install -g prettier
    else
        print_warning "npm not found, skipping prettier installation"
    fi

    print_status "Installing Go packages..."
    if command_exists go; then
        go install github.com/norwoodj/helm-docs/cmd/helm-docs@latest
    else
        print_warning "Go not found, skipping helm-docs installation"
    fi

    # Install system packages
    print_status "Installing system packages..."
    if command_exists brew; then
        print_status "Using Homebrew..."
        brew install shellcheck shfmt yq
    elif command_exists apt-get; then
        print_status "Using apt-get..."
        sudo apt-get update
        sudo apt-get install -y shellcheck shfmt yq
    elif command_exists yum; then
        print_status "Using yum..."
        sudo yum install -y ShellCheck yq
    else
        print_warning "Package manager not found. Please install manually:"
        echo "  - shellcheck"
        echo "  - shfmt"
        echo "  - yq"
    fi

    print_status "Setting up pre-commit hooks..."
    pre-commit install

    print_status "Making scripts executable..."
    chmod +x scripts/**/*.sh

    print_success "Installation completed successfully!"
    echo ""
    print_header "🎉 Next Steps"
    echo ""
    echo "1. Run 'make lint' to check your charts"
    echo "2. Run 'make format' to format your code"
    echo "3. Run 'make test' to run all tests"
    echo "4. Run 'make docs' to generate documentation"
    echo ""
    echo "For more information, see scripts/README.md"
}

# Function to show help
show_help() {
    echo "StackAI Helm Charts Development Tools Installer"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --help, -h    Show this help message"
    echo "  --check       Check if dependencies are installed"
    echo ""
    echo "This script installs all required dependencies for"
    echo "StackAI Helm charts development and testing."
}

# Function to check dependencies
check_dependencies() {
    print_header "🔍 Checking Dependencies"
    echo ""

    local missing_deps=()

    # Check required tools
    local tools=("python3" "pre-commit" "yamllint" "shellcheck" "shfmt" "yq")

    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            print_success "$tool ✓"
        else
            print_error "$tool ✗"
            missing_deps+=("$tool")
        fi
    done

    # Check optional tools
    local optional_tools=("node" "npm" "prettier" "go" "helm-docs")

    echo ""
    print_status "Optional tools:"
    for tool in "${optional_tools[@]}"; do
        if command_exists "$tool"; then
            print_success "$tool ✓"
        else
            print_warning "$tool ✗ (optional)"
            missing_deps+=("$tool")
        fi
    done

    echo ""
    if [[ ${#missing_deps[@]} -eq 0 ]]; then
        print_success "All dependencies are installed!"
    else
        print_warning "Missing dependencies: ${missing_deps[*]}"
        echo ""
        print_status "Run '$0' to install missing dependencies"
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --help|-h)
            show_help
            exit 0
            ;;
        --check)
            check_dependencies
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
install_dependencies
