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
| unstructured.env.DATABASE_URL | string | `""` |  |
| unstructured.env.DEBUG | string | `"false"` |  |
| unstructured.env.ENVIRONMENT | string | `"production"` |  |
| unstructured.env.LOG_LEVEL | string | `"INFO"` |  |
| unstructured.env.UNSTRUCTURED_API_KEY | string | `""` |  |
| unstructured.env.UNSTRUCTURED_PARALLEL_MODE_ENABLED | string | `"false"` |  |
| unstructured.env.UNSTRUCTURED_PARALLEL_MODE_RETRY_ATTEMPTS | string | `"2"` |  |
| unstructured.env.UNSTRUCTURED_PARALLEL_MODE_SPLIT_SIZE | string | `"1"` |  |
| unstructured.env.UNSTRUCTURED_PARALLEL_MODE_THREADS | string | `"3"` |  |
| unstructured.env.UNSTRUCTURED_PARALLEL_MODE_URL | string | `""` |  |
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
