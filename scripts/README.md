# StackAI Helm Charts Development Tools

This directory contains comprehensive development tools for managing, linting, formatting, and documenting StackAI Helm charts.

## 🚀 Quick Start

### First Time Setup

```bash
# Install all dependencies
make install-deps

# Run full development cycle
make all
```

### Daily Development

```bash
# Check code quality
make lint

# Format code
make format

# Run tests
make test

# Generate documentation
make docs

# Check versions
make version
```

## 📁 Directory Structure

```
scripts/
├── config/                 # Configuration files
│   ├── .prettierrc.yaml   # Prettier configuration for YAML
│   └── .yamllint          # YAML linting rules
├── docs/                   # Documentation generation
│   └── generate-helm-docs.sh
├── lint/                   # Linting and validation
│   └── helm-template-test.sh
├── version/                # Version management
│   ├── version-check.sh
│   ├── version-manager.sh
│   └── version-config.yaml
├── Makefile               # Development workflow
└── README.md              # This file
```

## 🛠️ Available Tools

### 1. Linting and Validation

#### YAML Linting

- **yamllint**: Validates YAML syntax and style
- **prettier**: Formats YAML files consistently
- **Configuration**: `config/.yamllint` and `config/.prettierrc.yaml`

#### Helm Chart Validation

- **helm lint**: Validates Helm chart structure
- **helm template**: Tests template rendering
- **helm install --dry-run**: Validates installation
- **Custom checks**: Template syntax and value validation

#### Shell Script Linting

- **shellcheck**: Static analysis for shell scripts
- **shfmt**: Shell script formatter

### 2. Documentation Generation

#### Helm Chart Documentation

- **helm-docs**: Auto-generates README.md from values.yaml
- **Comprehensive docs**: Creates overview documentation
- **Template validation**: Ensures documentation accuracy

#### Features

- Automatic parameter tables
- Example configurations
- Installation instructions
- Security considerations

### 3. Version Management

#### Version Checking

- Validates chart versions across all components
- Ensures consistency between infrastructure and application charts
- Supports different versioning strategies

#### Version Configuration

- Centralized version management in `version-config.yaml`
- Semantic versioning support
- Group-based version updates

### 4. Pre-commit Hooks

#### Automated Checks

- YAML formatting and linting
- Helm chart validation
- Version consistency checks
- Shell script formatting
- Documentation generation

## 📋 Available Make Targets

### Core Targets

| Target | Description | Example |
|--------|-------------|---------|
| `help` | Show help message | `make help` |
| `install-deps` | Install all dependencies | `make install-deps` |
| `lint` | Run all linting checks | `make lint` |
| `format` | Format all files | `make format` |
| `test` | Run all tests | `make test` |
| `docs` | Generate documentation | `make docs` |
| `version` | Check versions | `make version` |
| `clean` | Clean generated files | `make clean` |

### Development Workflow

| Target | Description | Example |
|--------|-------------|---------|
| `dev-setup` | Complete development setup | `make dev-setup` |
| `ci` | CI/CD pipeline | `make ci` |
| `all` | Full development cycle | `make all` |
| `quick-check` | Fast pre-commit check | `make quick-check` |

### Specific Tools

| Target | Description | Example |
|--------|-------------|---------|
| `lint-yaml` | Lint YAML files only | `make lint-yaml` |
| `lint-helm` | Lint Helm charts only | `make lint-helm` |
| `lint-shell` | Lint shell scripts only | `make lint-shell` |
| `format-yaml` | Format YAML files only | `make format-yaml` |
| `format-shell` | Format shell scripts only | `make format-shell` |

### Version Management

| Target | Description | Example |
|--------|-------------|---------|
| `version-update` | Update all versions | `make version-update` |
| `version-config` | Show version config | `make version-config` |

### Pre-commit

| Target | Description | Example |
|--------|-------------|---------|
| `install-hooks` | Install pre-commit hooks | `make install-hooks` |
| `update-hooks` | Update pre-commit hooks | `make update-hooks` |

## 🔧 Configuration

### YAML Formatting (Prettier)

Configuration: `config/.prettierrc.yaml`

```yaml
yaml:
  tabWidth: 2
  printWidth: 80
  singleQuote: true
  endOfLine: "lf"
```

### YAML Linting (yamllint)

Configuration: `config/.yamllint`

- Line length: 120 characters
- Indentation: 2 spaces
- Consistent quoting
- No trailing spaces

### Version Management

Configuration: `version/version-config.yaml`

- Centralized version definitions
- Component-specific app versions
- Release information
- Versioning strategy

## 🚦 Pre-commit Hooks

### Automatic Checks

The pre-commit configuration (`.pre-commit-config.yaml`) includes:

1. **Basic Checks**
   - Trailing whitespace removal
   - End-of-file fixes
   - Large file detection
   - Merge conflict detection

2. **YAML Processing**
   - Prettier formatting
   - yamllint validation
   - JSON/TOML/XML validation

3. **Helm Validation**
   - Chart linting
   - Template testing
   - Version checking

4. **Documentation**
   - Auto-generation of Helm docs
   - README updates

5. **Shell Scripts**
   - shellcheck linting
   - shfmt formatting

### Installation

```bash
# Install pre-commit hooks
make install-hooks

# Or manually
pre-commit install
```

### Usage

```bash
# Run on all files
pre-commit run --all-files

# Run on staged files only
git commit -m "Your commit message"
```

## 📚 Documentation Generation

### Helm Chart Documentation

Each Helm chart automatically generates documentation from its `values.yaml` file:

```bash
# Generate docs for all charts
make docs

# Generate docs for specific chart
./docs/generate-helm-docs.sh chart --chart-dir helm/infra/mongo
```

### Generated Documentation Includes

- **Parameter Tables**: All configurable values
- **Examples**: Common configuration scenarios
- **Installation Instructions**: Step-by-step setup
- **Security Notes**: Best practices and considerations
- **Troubleshooting**: Common issues and solutions

### Comprehensive Documentation

```bash
# Generate overview documentation
./docs/generate-helm-docs.sh comprehensive
```

Creates:

- `docs/helm/README.md`: Overview of all charts
- Individual chart documentation
- Installation guides
- Configuration references

## 🔍 Linting and Validation

### Helm Chart Validation

```bash
# Test all Helm charts
make lint-helm

# Test specific chart
./lint/helm-template-test.sh
```

**Validation Checks:**

- Chart structure validation
- Template syntax checking
- Values validation
- Dry-run installation testing
- Common template issues detection

### YAML Validation

```bash
# Lint all YAML files
make lint-yaml

# Format YAML files
make format-yaml
```

**Validation Rules:**

- Syntax validation
- Style consistency
- Indentation rules
- Line length limits
- Quoting consistency

### Shell Script Validation

```bash
# Lint shell scripts
make lint-shell

# Format shell scripts
make format-shell
```

**Validation Rules:**

- Static analysis with shellcheck
- Consistent formatting with shfmt
- Best practice enforcement

## 📋 Version Management

### Version Checking

```bash
# Check all chart versions
make version

# Update all versions
make version-update

# Show version configuration
make version-config
```

### Version Strategy

**Chart Versions**: All charts use version `1.0.0` for consistency

**App Versions**:

- **Infrastructure**: Use actual software versions (MongoDB 7.0.0, Redis 7.2.0, etc.)
- **Application**: Use StackAI release versions (1.0.0)

**Version Groups**:

- **Infrastructure**: MongoDB, Redis, Weaviate, Supabase, Nginx
- **Application**: Stackend, Stackweb, Celery, Repl

### Version Bumping

```bash
# Update version configuration
vim scripts/version/version-config.yaml

# Apply version updates
make version-update

# Verify changes
make version
```

## 🧪 Testing

### Test Suite

```bash
# Run all tests
make test

# Run specific tests
make lint-helm
make version
```

### Test Coverage

- **Helm Templates**: Template rendering and validation
- **Version Consistency**: Cross-chart version validation
- **YAML Syntax**: File structure and syntax
- **Shell Scripts**: Script functionality and syntax

## 🚀 CI/CD Integration

### GitHub Actions

```yaml
name: Helm Charts CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup development environment
        run: make install-deps
      - name: Run tests
        run: make ci
```

### Pre-commit Integration

```bash
# Install pre-commit hooks
make install-hooks

# Update hooks
make update-hooks
```

## 🛠️ Troubleshooting

### Common Issues

1. **Missing Dependencies**

   ```bash
   # Install all dependencies
   make install-deps
   ```

2. **Pre-commit Hook Failures**

   ```bash
   # Run hooks manually
   pre-commit run --all-files

   # Update hooks
   make update-hooks
   ```

3. **Helm Template Errors**

   ```bash
   # Test specific chart
   helm template chart-name helm/chart-dir

   # Debug template rendering
   helm template chart-name helm/chart-dir --debug
   ```

4. **Version Mismatches**

   ```bash
   # Check current versions
   make version

   # Update versions
   make version-update
   ```

### Debug Mode

```bash
# Enable debug output
set -x
make lint
set +x
```

## 🤝 Contributing

### Development Workflow

1. **Setup Environment**

   ```bash
   make dev-setup
   ```

2. **Make Changes**
   - Edit Helm charts
   - Update configurations
   - Add new features

3. **Validate Changes**

   ```bash
   make lint
   make test
   make docs
   ```

4. **Commit Changes**

   ```bash
   git add .
   git commit -m "Your changes"
   ```

### Adding New Charts

1. **Create Chart Structure**

   ```bash
   helm create helm/new-chart
   ```

2. **Update Version Configuration**

   ```yaml
   # Add to scripts/version/version-config.yaml
   new-chart:
     chartVersion: "1.0.0"
     appVersion: "1.0.0"
   ```

3. **Test Chart**

   ```bash
   make lint-helm
   make test
   ```

4. **Generate Documentation**

   ```bash
   make docs
   ```

## 📄 License

This project is part of StackAI and follows the same license terms.

## 🆘 Support

For issues and questions:

- **GitHub Issues**: <https://github.com/stackai/stackai-helm/issues>
- **Documentation**: <https://docs.stackai.com>
- **Support**: <support@stackai.com>
