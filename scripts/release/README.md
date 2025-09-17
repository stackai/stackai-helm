# StackAI Helm Charts Release Process

This directory contains tools and configurations for releasing StackAI Helm charts as separate, versioned packages.

## 🚀 Overview

The StackAI Helm charts are released as individual packages, allowing users to install only the components they need. Each chart is versioned independently and published to a GitHub Pages-hosted Helm repository.

## 📦 Available Charts

### Infrastructure Charts

- **stackai-mongo** - MongoDB database for StackAI applications
- **stackai-redis** - Redis in-memory data store
- **stackai-weaviate** - Weaviate vector database
- **stackai-supabase** - Supabase backend-as-a-service
- **stackai-nginx-ingress** - Nginx Ingress Controller

### Application Charts

- **stackai-stackend** - StackAI backend API service
- **stackai-stackweb** - StackAI frontend web application
- **stackai-celery** - Background task processing
- **stackai-repl** - StackAI Repl API service

## 🔧 Release Configuration

### Chart Releaser Configuration (`cr.yaml`)

The `cr.yaml` file configures how charts are packaged and released:

```yaml
owner: stackai
git-repo: stackai-helm
package-path: .cr-release-packages
index-path: index.yaml
pages-branch: gh-pages
charts-repo: https://stackai.github.io/stackai-helm/

# Chart directories to scan
charts-dirs:
  - helm/infra
  - helm/app

# Naming patterns
chart-name-pattern: "stackai-{{ .Name }}"
release-name-pattern: "stackai-{{ .Name }}"
```

### GitHub Actions Workflows

#### 1. Test Charts (`.github/workflows/test-charts.yml`)

- Runs on every push and pull request
- Tests chart linting and template rendering
- Validates with different value configurations
- Runs comprehensive quality checks

#### 2. Release Charts (`.github/workflows/release.yml`)

- Runs on pushes to main branch
- Detects which charts have changed
- Packages and releases only changed charts
- Updates the Helm repository index
- Creates release summaries

## 🛠️ Release Tools

### Release Script (`release-charts.sh`)

A comprehensive script for managing chart releases:

```bash
# Full release process
./scripts/release/release-charts.sh release

# Package all charts
./scripts/release/release-charts.sh package

# Validate all charts
./scripts/release/release-charts.sh validate

# Generate repository index
./scripts/release/release-charts.sh index

# List all charts
./scripts/release/release-charts.sh list

# Clean up generated files
./scripts/release/release-charts.sh clean
```

### Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `release` | Full release process (validate + package + index) | `./release-charts.sh release` |
| `package` | Package all charts into .tgz files | `./release-charts.sh package` |
| `validate` | Validate all charts (lint + template test) | `./release-charts.sh validate` |
| `index` | Generate Helm repository index | `./release-charts.sh index` |
| `list` | List all available charts with versions | `./release-charts.sh list` |
| `clean` | Clean up generated files | `./release-charts.sh clean` |

## 📋 Release Process

### Automatic Release (GitHub Actions)

1. **Code Push**: Developer pushes changes to main branch
2. **Change Detection**: Workflow detects which charts changed
3. **Testing**: Charts are validated and tested
4. **Packaging**: Changed charts are packaged
5. **Release**: Charts are released to GitHub Pages
6. **Index Update**: Repository index is updated
7. **Summary**: Release summary is generated

### Manual Release

1. **Validate Charts**:

   ```bash
   ./scripts/release/release-charts.sh validate
   ```

2. **Package Charts**:

   ```bash
   ./scripts/release/release-charts.sh package
   ```

3. **Generate Index**:

   ```bash
   ./scripts/release/release-charts.sh index
   ```

4. **Commit and Push**:

   ```bash
   git add index.yaml
   git commit -m "chore: release charts v1.0.0"
   git push origin main
   ```

## 🎯 Chart Versioning

### Version Strategy

- **Chart Version**: Semantic versioning (e.g., 1.0.0)
- **App Version**: Actual software version (e.g., MongoDB 7.0.0)
- **Independent Versioning**: Each chart is versioned independently

### Version Management

Charts are versioned using the `version` and `appVersion` fields in `Chart.yaml`:

```yaml
apiVersion: v2
name: stackai-mongo
description: MongoDB for StackAI
type: application
version: 1.0.0
appVersion: 7.0.0
```

### Version Updates

Use the version management scripts to update versions:

```bash
# Check current versions
./scripts/version/version-check.sh check

# Update all versions
./scripts/version/version-check.sh update
```

## 📚 Installation

### Add StackAI Helm Repository

```bash
helm repo add stackai https://stackai.github.io/stackai-helm/
helm repo update
```

### Install Individual Charts

```bash
# Install MongoDB
helm install mongodb stackai/stackai-mongo

# Install Redis
helm install redis stackai/stackai-redis

# Install Stackend
helm install stackend stackai/stackai-stackend

# Install with custom values
helm install mongodb stackai/stackai-mongo -f my-values.yaml
```

### Install All Infrastructure

```bash
# Install all infrastructure components
helm install mongodb stackai/stackai-mongo
helm install redis stackai/stackai-redis
helm install weaviate stackai/stackai-weaviate
helm install supabase stackai/stackai-supabase
helm install nginx stackai/stackai-nginx-ingress
```

### Install All Applications

```bash
# Install all application components
helm install stackend stackai/stackai-stackend
helm install stackweb stackai/stackai-stackweb
helm install celery stackai/stackai-celery
helm install repl stackai/stackai-repl
```

## 🔍 Quality Assurance

### Pre-Release Testing

1. **Chart Linting**: `helm lint` validates chart structure
2. **Template Testing**: `helm template` tests template rendering
3. **Value Validation**: Tests with different value configurations
4. **YAML Linting**: Validates YAML syntax and style
5. **Shell Script Linting**: Validates shell scripts
6. **Version Consistency**: Ensures version consistency across charts

### Continuous Integration

- **Automated Testing**: Every push triggers comprehensive tests
- **Change Detection**: Only changed charts are tested and released
- **Quality Gates**: Failed tests prevent releases
- **Comprehensive Coverage**: Tests cover all chart types and configurations

## 🚨 Troubleshooting

### Common Issues

1. **Chart Linting Failures**

   ```bash
   # Test specific chart
   helm lint helm/infra/mongo

   # Fix common issues
   helm lint helm/infra/mongo --strict
   ```

2. **Template Rendering Errors**

   ```bash
   # Debug template rendering
   helm template mongo helm/infra/mongo --debug

   # Test with specific values
   helm template mongo helm/infra/mongo -f examples/values/dev/mongo-local.yaml
   ```

3. **Version Conflicts**

   ```bash
   # Check version consistency
   ./scripts/version/version-check.sh check

   # Update versions
   ./scripts/version/version-check.sh update
   ```

4. **Release Failures**

   ```bash
   # Clean up and retry
   ./scripts/release/release-charts.sh clean
   ./scripts/release/release-charts.sh release
   ```

### Debug Mode

Enable debug output for troubleshooting:

```bash
# Enable bash debug mode
set -x
./scripts/release/release-charts.sh release
set +x
```

## 📖 Documentation

### Chart Documentation

Each chart includes comprehensive documentation:

- **README.md**: Installation and configuration guide
- **values.yaml**: All configurable parameters with descriptions
- **Examples**: Common configuration scenarios
- **Security Notes**: Best practices and security considerations

### Generated Documentation

The release process automatically generates:

- **Repository Index**: `index.yaml` with all available charts
- **Release Notes**: Detailed changelog for each release
- **Installation Instructions**: Step-by-step setup guides

## 🤝 Contributing

### Adding New Charts

1. **Create Chart Structure**:

   ```bash
   helm create helm/category/new-chart
   ```

2. **Update Configuration**:
   - Add chart to `cr.yaml` if needed
   - Update version configuration
   - Add to test workflows

3. **Test Chart**:

   ```bash
   ./scripts/release/release-charts.sh validate
   ```

4. **Release Chart**:

   ```bash
   ./scripts/release/release-charts.sh release
   ```

### Modifying Existing Charts

1. **Make Changes**: Edit chart templates and values
2. **Update Version**: Increment chart version in `Chart.yaml`
3. **Test Changes**: Run validation and tests
4. **Commit Changes**: Push to main branch
5. **Automatic Release**: GitHub Actions handles the release

## 📄 License

This project is part of StackAI and follows the same license terms.

## 🆘 Support

For issues and questions:

- **GitHub Issues**: <https://github.com/stackai/stackai-helm/issues>
- **Documentation**: <https://docs.stackai.com>
- **Support**: <support@stackai.com>
