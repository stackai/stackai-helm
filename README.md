# StackAI Helm Charts

[![Release Charts](https://github.com/stackai/stackai-helm/actions/workflows/release.yml/badge.svg)](https://github.com/stackai/stackai-helm/actions/workflows/release.yml)

Official Helm charts for StackAI - the complete AI development platform. Deploy StackAI infrastructure and applications on Kubernetes with ease.

## 🚀 Quick Start

### Add StackAI Helm Repository

```bash
helm repo add stackai https://stackai.github.io/stackai-helm/
helm repo update
```

### Install Infrastructure

```bash
# MongoDB database
helm install mongodb stackai/stackai-mongo

# Redis cache
helm install redis stackai/stackai-redis

# Weaviate vector database
helm install weaviate stackai/stackai-weaviate

# Supabase backend
helm install supabase stackai/stackai-supabase

# Nginx Ingress Controller
helm install nginx stackai/stackai-nginx-ingress
```

### Install Applications

```bash
# StackAI Backend API
helm install stackend stackai/stackai-stackend

# StackAI Frontend
helm install stackweb stackai/stackai-stackweb

# Background Tasks
helm install celery stackai/stackai-celery

# Repl API
helm install repl stackai/stackai-repl
```

## 📦 Available Charts

### Infrastructure Charts

| Chart | Description | Version |
|-------|-------------|---------|
| [stackai-mongo](helm/infra/mongo) | MongoDB database for StackAI | ![MongoDB](https://img.shields.io/badge/version-1.0.0-blue) |
| [stackai-redis](helm/infra/redis) | Redis in-memory data store | ![Redis](https://img.shields.io/badge/version-1.0.0-blue) |
| [stackai-weaviate](helm/infra/weviate) | Weaviate vector database | ![Weaviate](https://img.shields.io/badge/version-1.0.0-blue) |
| [stackai-supabase](helm/infra/supabase) | Supabase backend-as-a-service | ![Supabase](https://img.shields.io/badge/version-1.0.0-blue) |
| [stackai-nginx-ingress](helm/infra/nginx) | Nginx Ingress Controller | ![Nginx](https://img.shields.io/badge/version-1.0.0-blue) |

### Application Charts

| Chart | Description | Version |
|-------|-------------|---------|
| [stackai-stackend](helm/app/stackend) | StackAI backend API service | ![Stackend](https://img.shields.io/badge/version-1.0.0-blue) |
| [stackai-stackweb](helm/app/stackweb) | StackAI frontend web application | ![Stackweb](https://img.shields.io/badge/version-1.0.0-blue) |
| [stackai-celery](helm/app/celery) | Background task processing | ![Celery](https://img.shields.io/badge/version-1.0.0-blue) |
| [stackai-repl](helm/app/repl) | StackAI Repl API service | ![Repl](https://img.shields.io/badge/version-1.0.0-blue) |

## 🛠️ Configuration

### Custom Values

Each chart supports extensive customization through values files:

```bash
# Install with custom values
helm install mongodb stackai/stackai-mongo -f my-values.yaml

# Override specific values
helm install redis stackai/stackai-redis \
  --set persistence.enabled=true \
  --set resources.requests.memory=512Mi
```

### Environment-Specific Deployments

```bash
# Development environment
helm install stackend stackai/stackai-stackend \
  -f examples/values/dev/stackend-local.yaml

# Production environment
helm install stackend stackai/stackai-stackend \
  -f examples/values/prod/stackend-production.yaml
```

## 🔧 Development

### Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- kubectl

### Local Development

```bash
# Clone the repository
git clone https://github.com/stackai/stackai-helm.git
cd stackai-helm

# Install development tools
make install-deps

# Validate charts
make validate-charts

# Test charts
make test

# Package charts
make package
```

## 📚 Documentation

- [Chart Documentation](docs/helm/) - Detailed chart documentation
- [Examples](examples/) - Configuration examples
- [Development Guide](scripts/README.md) - Development tools and workflows
- [Release Process](scripts/release/README.md) - Chart release process

## 🌟 Features

- **Production Ready**: Battle-tested in production environments
- **Highly Configurable**: Extensive customization options
- **Security First**: Built with security best practices
- **Cloud Native**: Designed for Kubernetes
- **Well Documented**: Comprehensive documentation and examples
- **CI/CD Ready**: Automated testing and release pipelines

## 📊 Monitoring

Charts include built-in monitoring and observability:

- Health checks and readiness probes
- Prometheus metrics endpoints
- Structured logging
- Resource monitoring
- Alerting rules

## About StackAI

[Website](https://stackai.com) • [Documentation](https://docs.stackai.com) • [GitHub](https://github.com/stackai) • [Twitter](https://twitter.com/stackai)

**Made with ❤️ by the StackAI Team**
