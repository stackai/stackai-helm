# StackAI Helm Charts

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
helm install mongodb stackai/stackai-mongodb

# Redis cache
helm install redis stackai/stackai-redis

# Weaviate vector database
helm install weaviate stackai/stackai-weaviate

# Supabase backend
helm install supabase stackai/stackai-supabase

# Nginx Ingress Controller
helm install nginx stackai/stackai-nginx-ingress

# PostgreSQL database
helm install postgres stackai/postgres
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

# Temporal Workflow Engine
helm install temporal stackai/stackai-temporal

# Unstructured API
helm install unstructured stackai/stackai-unstructured
```

## 🛠️ Configuration

### Custom Values

Each chart supports extensive customization through values files:

```bash
# Install with custom values
helm install mongodb stackai/stackai-mongodb -f my-values.yaml

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

## 📚 Documentation

- [Chart Documentation](helm/README.md) - Detailed chart documentation
- [Release Process](scripts/release/README.md) - Chart release process

## 🌟 Features

- **Production Ready**: Battle-tested in production environments
- **Highly Configurable**: Extensive customization options
- **Security First**: Built with security best practices
- **Cloud Native**: Designed for Kubernetes
- **Well Documented**: Comprehensive documentation and examples
- **CI/CD Ready**: Automated testing and release pipelines

## About StackAI

[Website](https://stackai.com) • [Documentation](https://docs.stackai.com) • [GitHub](https://github.com/stackai) • [Twitter](https://twitter.com/stackai)
