# StackAI Helm Charts

Official Helm charts for StackAI - the complete AI development platform.

## 🚀 Quick Start

### Add StackAI Helm Repository

```bash
helm repo add stackai https://stackai.github.io/stackai-helm/
helm repo update
```

### Install Applications

```bash
# StackAI Backend API
helm install stackend stackai/stackend

# StackAI Frontend
helm install stackweb stackai/stackweb

# Repl API
helm install repl stackai/stackrepl

# Supabase
helm install supabase stackai/supabase

# Unstructured
helm install unstructured stackai/unstructured
```

## 🛠️ Configuration

### Custom Values

Each chart supports extensive customization through values files:

```bash
helm install stackend stackai/stackend \
  -f examples/values/stackend.yaml
```

## 📚 Documentation

[Stackend Documentation](https://stackai.github.io/stackai-helm/helm/stackend)
[Stackweb Documentation](https://stackai.github.io/stackai-helm/helm/stackweb)
[Stackrepl Documentation](https://stackai.github.io/stackai-helm/helm/stackrepl)
[Supabase Documentation](https://stackai.github.io/stackai-helm/helm/supabase)
[Unstructured Documentation](https://stackai.github.io/stackai-helm/helm/unstructured)

## 🌟 Features

- **Production Ready**: Battle-tested in production environments
- **Highly Configurable**: Extensive customization options
- **Security First**: Built with security best practices
- **Cloud Native**: Designed for Kubernetes
- **Well Documented**: Comprehensive documentation and examples
- **CI/CD Ready**: Automated testing and release pipelines

## About StackAI

[Website](https://stackai.com) • [Documentation](https://docs.stackai.com) • [GitHub](https://github.com/stackai) • [Twitter](https://twitter.com/stackai)
