# StackAI Helm Charts Development Tools Makefile

.PHONY: help install-deps lint format test docs version release clean

# Default target
help:
	@echo "StackAI Helm Charts Development Tools"
	@echo ""
	@echo "Available targets:"
	@echo "  help           Show this help message"
	@echo "  install-deps   Install required dependencies"
	@echo "  lint           Run all linting checks"
	@echo "  format         Format all files"
	@echo "  test           Run all tests"
	@echo "  docs           Generate documentation"
	@echo "  version        Check and manage versions"
	@echo "  release        Package and release charts"
	@echo "  package        Package charts only"
	@echo "  validate-charts Validate charts only"
	@echo "  list-charts    List available charts"
	@echo "  clean          Clean generated files"
	@echo ""
	@echo "Development workflow:"
	@echo "  make install-deps  # First time setup"
	@echo "  make lint          # Check code quality"
	@echo "  make format        # Format code"
	@echo "  make test          # Run tests"
	@echo "  make docs          # Generate docs"
	@echo "  make version       # Check versions"
	@echo "  make release       # Package and release"

# Install dependencies
install-deps:
	@echo "Installing development dependencies..."
	@echo ""
	@echo "Installing pre-commit..."
	pip install pre-commit
	@echo ""
	@echo "Installing yamllint..."
	pip install yamllint
	@echo ""
	@echo "Installing prettier..."
	npm install -g prettier
	@echo ""
	@echo "Installing helm-docs..."
	go install github.com/norwoodj/helm-docs/cmd/helm-docs@latest
	@echo ""
	@echo "Installing shellcheck..."
	@if command -v brew >/dev/null 2>&1; then \
		brew install shellcheck; \
	elif command -v apt-get >/dev/null 2>&1; then \
		sudo apt-get install shellcheck; \
	else \
		echo "Please install shellcheck manually"; \
	fi
	@echo ""
	@echo "Installing shfmt..."
	@if command -v brew >/dev/null 2>&1; then \
		brew install shfmt; \
	elif command -v apt-get >/dev/null 2>&1; then \
		sudo apt-get install shfmt; \
	else \
		echo "Please install shfmt manually"; \
	fi
	@echo ""
	@echo "Installing yq..."
	@if command -v brew >/dev/null 2>&1; then \
		brew install yq; \
	elif command -v apt-get >/dev/null 2>&1; then \
		sudo apt-get install yq; \
	else \
		echo "Please install yq manually"; \
	fi
	@echo ""
	@echo "Setting up pre-commit hooks..."
	pre-commit install
	@echo ""
	@echo "✅ All dependencies installed successfully!"

# Lint all files
lint:
	@echo "🔍 Running linting checks..."
	@echo ""
	@echo "Running pre-commit hooks..."
	pre-commit run --all-files
	@echo ""
	@echo "Running Helm template tests..."
	./lint/helm-template-test.sh
	@echo ""
	@echo "✅ All linting checks passed!"

# Format all files
format:
	@echo "🎨 Formatting files..."
	@echo ""
	@echo "Formatting YAML files with prettier..."
	prettier --write "**/*.yaml" --config config/.prettierrc.yaml
	@echo ""
	@echo "Formatting shell scripts with shfmt..."
	find . -name "*.sh" -type f -exec shfmt -w -i 2 -ci -sr {} \;
	@echo ""
	@echo "✅ All files formatted!"

# Test all components
test:
	@echo "🧪 Running tests..."
	@echo ""
	@echo "Testing Helm templates..."
	./lint/helm-template-test.sh
	@echo ""
	@echo "Testing version consistency..."
	./version/version-check.sh check
	@echo ""
	@echo "✅ All tests passed!"

# Generate documentation
docs:
	@echo "📚 Generating documentation..."
	@echo ""
	@echo "Generating Helm chart documentation..."
	./docs/generate-helm-docs.sh generate
	@echo ""
	@echo "Generating comprehensive documentation..."
	./docs/generate-helm-docs.sh comprehensive
	@echo ""
	@echo "✅ Documentation generated!"

# Version management
version:
	@echo "📋 Version management..."
	@echo ""
	@echo "Checking current versions..."
	./version/version-check.sh check
	@echo ""
	@echo "Showing version status..."
	@if [ -f "./version/version-status.sh" ]; then \
		./version/version-status.sh; \
	else \
		echo "Version status script not found"; \
	fi

# Update versions
version-update:
	@echo "🔄 Updating versions..."
	./version/version-check.sh update
	@echo "✅ Versions updated!"

# Show version configuration
version-config:
	@echo "📋 Version configuration..."
	@if [ -f "./version/version-manager.sh" ]; then \
		./version/version-manager.sh config; \
	else \
		echo "Version manager not found"; \
	fi

# Clean generated files
clean:
	@echo "🧹 Cleaning generated files..."
	@echo ""
	@echo "Removing backup files..."
	find . -name "*.bak" -type f -delete
	@echo ""
	@echo "Removing temporary files..."
	find . -name "*.tmp" -type f -delete
	@echo ""
	@echo "Cleaning pre-commit cache..."
	pre-commit clean
	@echo ""
	@echo "✅ Cleanup completed!"

# Development workflow
dev-setup: install-deps
	@echo "🚀 Development environment setup complete!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Run 'make lint' to check code quality"
	@echo "  2. Run 'make format' to format your code"
	@echo "  3. Run 'make test' to run all tests"
	@echo "  4. Run 'make docs' to generate documentation"

# CI/CD pipeline
ci: lint test docs version
	@echo "✅ CI pipeline completed successfully!"

# Release charts
release:
	@echo "🚀 Releasing Helm charts..."
	@echo ""
	@echo "Validating charts..."
	./release/release-charts.sh validate
	@echo ""
	@echo "Packaging charts..."
	./release/release-charts.sh package
	@echo ""
	@echo "Generating repository index..."
	./release/release-charts.sh index
	@echo ""
	@echo "✅ Charts released successfully!"

# Package charts only
package:
	@echo "📦 Packaging Helm charts..."
	./release/release-charts.sh package
	@echo "✅ Charts packaged successfully!"

# Validate charts only
validate-charts:
	@echo "🔍 Validating Helm charts..."
	./release/release-charts.sh validate
	@echo "✅ Charts validated successfully!"

# List available charts
list-charts:
	@echo "📋 Available Helm charts:"
	./release/release-charts.sh list

# Full development cycle
all: install-deps lint format test docs version
	@echo "🎉 Full development cycle completed successfully!"

# Quick check (for pre-commit)
quick-check:
	@echo "⚡ Running quick checks..."
	./version/version-check.sh check
	@echo "✅ Quick check completed!"

# Install pre-commit hooks
install-hooks:
	@echo "🔧 Installing pre-commit hooks..."
	pre-commit install
	pre-commit install --hook-type commit-msg
	@echo "✅ Pre-commit hooks installed!"

# Update pre-commit hooks
update-hooks:
	@echo "🔄 Updating pre-commit hooks..."
	pre-commit autoupdate
	@echo "✅ Pre-commit hooks updated!"

# Run specific linters
lint-yaml:
	@echo "🔍 Linting YAML files..."
	yamllint -c config/.yamllint .
	@echo "✅ YAML linting completed!"

lint-helm:
	@echo "🔍 Linting Helm charts..."
	./lint/helm-template-test.sh
	@echo "✅ Helm linting completed!"

lint-shell:
	@echo "🔍 Linting shell scripts..."
	find . -name "*.sh" -type f -exec shellcheck {} \;
	@echo "✅ Shell script linting completed!"

# Format specific file types
format-yaml:
	@echo "🎨 Formatting YAML files..."
	prettier --write "**/*.yaml" --config config/.prettierrc.yaml
	@echo "✅ YAML formatting completed!"

format-shell:
	@echo "🎨 Formatting shell scripts..."
	find . -name "*.sh" -type f -exec shfmt -w -i 2 -ci -sr {} \;
	@echo "✅ Shell script formatting completed!"
