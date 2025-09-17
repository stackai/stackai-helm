# stackai-unstructured

![Version: 1.1.0](https://img.shields.io/badge/Version-1.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.1.0](https://img.shields.io/badge/AppVersion-1.1.0-informational?style=flat-square)

Official StackAI Unstructured API Helm chart.

**Homepage:** <https://stackai.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| StackAI | <support@stackai.com> |  |

## Source Code

* <https://github.com/stackai/stackai-helm>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| externalSecrets.enabled | bool | `false` |  |
| extraObjects | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt-prod"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/proxy-body-size" | string | `"50m"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/proxy-read-timeout" | string | `"300"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/proxy-send-timeout" | string | `"300"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/rewrite-target" | string | `"/"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/ssl-redirect" | string | `"false"` |  |
| ingress.className | string | `"nginx"` |  |
| ingress.enabled | bool | `true` |  |
| ingress.hosts[0].host | string | `"unstructured-api.yourdomain.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.tls[0].hosts[0] | string | `"unstructured-api.yourdomain.com"` |  |
| ingress.tls[0].secretName | string | `"unstructured-tls"` |  |
| nameOverride | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| unstructured.affinity | object | `{}` |  |
| unstructured.enabled | bool | `true` |  |
| unstructured.env.DEBUG | string | `"false"` |  |
| unstructured.env.ENVIRONMENT | string | `"production"` |  |
| unstructured.env.LOG_LEVEL | string | `"INFO"` |  |
| unstructured.env.UNSTRUCTURED_PARALLEL_MODE_ENABLED | string | `"false"` |  |
| unstructured.env.UNSTRUCTURED_PARALLEL_MODE_RETRY_ATTEMPTS | string | `"2"` |  |
| unstructured.env.UNSTRUCTURED_PARALLEL_MODE_SPLIT_SIZE | string | `"1"` |  |
| unstructured.env.UNSTRUCTURED_PARALLEL_MODE_THREADS | string | `"3"` |  |
| unstructured.env.UNSTRUCTURED_PARALLEL_MODE_URL | string | `""` |  |
| unstructured.env.DATABASE_URL | string | `""` |  |
| unstructured.env.UNSTRUCTURED_API_KEY | string | `""` |  |
| unstructured.image.pullPolicy | string | `"IfNotPresent"` |  |
| unstructured.image.repository | string | `"downloads.unstructured.io/unstructured-io/unstructured-api"` |  |
| unstructured.image.tag | string | `"0.0.80"` |  |
| unstructured.livenessProbe.enabled | bool | `true` |  |
| unstructured.livenessProbe.failureThreshold | int | `3` |  |
| unstructured.livenessProbe.httpGet.path | string | `"/general/v0/general"` |  |
| unstructured.livenessProbe.httpGet.port | string | `"http"` |  |
| unstructured.livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| unstructured.livenessProbe.initialDelaySeconds | int | `30` |  |
| unstructured.livenessProbe.periodSeconds | int | `30` |  |
| unstructured.livenessProbe.successThreshold | int | `1` |  |
| unstructured.livenessProbe.timeoutSeconds | int | `10` |  |
| unstructured.nodeSelector | object | `{}` |  |
| unstructured.podSecurityContext.enabled | bool | `true` |  |
| unstructured.podSecurityContext.fsGroup | int | `1000` |  |
| unstructured.podSecurityContext.runAsGroup | int | `1000` |  |
| unstructured.podSecurityContext.runAsNonRoot | bool | `true` |  |
| unstructured.podSecurityContext.runAsUser | int | `1000` |  |
| unstructured.readinessProbe.enabled | bool | `true` |  |
| unstructured.readinessProbe.failureThreshold | int | `3` |  |
| unstructured.readinessProbe.httpGet.path | string | `"/general/v0/general"` |  |
| unstructured.readinessProbe.httpGet.port | string | `"http"` |  |
| unstructured.readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| unstructured.readinessProbe.initialDelaySeconds | int | `10` |  |
| unstructured.readinessProbe.periodSeconds | int | `10` |  |
| unstructured.readinessProbe.successThreshold | int | `1` |  |
| unstructured.readinessProbe.timeoutSeconds | int | `5` |  |
| unstructured.replicaCount | int | `1` |  |
| unstructured.resources.limits.cpu | string | `"1000m"` |  |
| unstructured.resources.limits.memory | string | `"1Gi"` |  |
| unstructured.resources.requests.cpu | string | `"200m"` |  |
| unstructured.resources.requests.memory | string | `"512Mi"` |  |
| unstructured.securityContext.enabled | bool | `true` |  |
| unstructured.securityContext.fsGroup | int | `1000` |  |
| unstructured.securityContext.runAsGroup | int | `1000` |  |
| unstructured.securityContext.runAsNonRoot | bool | `true` |  |
| unstructured.securityContext.runAsUser | int | `1000` |  |
| unstructured.service.ports.http | int | `8000` |  |
| unstructured.service.type | string | `"ClusterIP"` |  |
| unstructured.tolerations | list | `[]` |  |

## Description

The StackAI Unstructured API Helm chart provides a production-ready deployment of the Unstructured API service for document processing in LLM and RAG applications. This chart uses the public Unstructured API image and is configured entirely through Helm values without requiring external secret management.

## Features

* **Production-ready**: Configured with proper resource limits, health checks, and security contexts
* **Public Image**: Uses the official Unstructured API public Docker image
* **Simple Configuration**: Environment variables configured directly through Helm values
* **Ingress Support**: NGINX ingress with TLS termination and cert-manager integration
* **Scalable**: Supports horizontal pod autoscaling and custom resource allocation
* **Configurable**: Extensive configuration options for the Unstructured API

## Prerequisites

* Kubernetes 1.19+
* Helm 3.0+
* NGINX Ingress Controller (if using ingress)
* cert-manager (if using TLS certificates)

## Installation

```bash
# Add the StackAI Helm repository (when available)
helm repo add stackai https://stackai.github.io/stackai-helm

# Install the chart
helm install unstructured stackai/stackai-unstructured \
  --namespace unstructured \
  --create-namespace \
  --values values.yaml
```

## Configuration

The chart can be configured through the `values.yaml` file. Key configuration areas include:

### Image Configuration

Configure the container image and pull policy:

```yaml
unstructured:
  image:
    repository: "downloads.unstructured.io/unstructured-io/unstructured-api"
    tag: "0.0.80"
    pullPolicy: IfNotPresent
```

### Resource Management

Set appropriate resource limits and requests:

```yaml
unstructured:
  resources:
    requests:
      memory: 512Mi
      cpu: 200m
    limits:
      memory: 1Gi
      cpu: 1000m
```

### Ingress Configuration

Enable and configure ingress for external access:

```yaml
ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: unstructured-api.yourdomain.com
      paths:
        - path: /
          pathType: Prefix
```

### External Secrets

Configure Azure Key Vault integration:

```yaml
externalSecrets:
  enabled: true
  secretStore:
    vaultUrl: "https://your-keyvault.vault.azure.net/"
    tenantId: "your-tenant-id"
    servicePrincipal:
      clientId: "your-client-id"
```

## Security

This chart implements security best practices:

* Non-root container execution
* Read-only root filesystem options
* Security contexts for pods and containers
* External secret management
* Network policies support (when configured)

## Monitoring

The chart includes health checks and monitoring endpoints:

* Liveness probe on `/general/v0/general`
* Readiness probe on `/general/v0/general`
* Configurable probe timing and thresholds
