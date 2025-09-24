# stackai-stackend

![Version: 1.1.5](https://img.shields.io/badge/Version-1.1.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.1.5](https://img.shields.io/badge/AppVersion-1.1.5-informational?style=flat-square)

Official StackAI Stackend Backend Helm chart.

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
| externalSecrets.enabled | bool | `true` |  |
| externalSecrets.secretStore.class | string | `"azure-keyvault"` |  |
| externalSecrets.secretStore.name | string | `"azure-keyvault-store"` |  |
| externalSecrets.secretStore.servicePrincipal.clientId | string | `"your-client-id"` |  |
| externalSecrets.secretStore.servicePrincipal.clientSecretRef.key | string | `"client-secret"` |  |
| externalSecrets.secretStore.servicePrincipal.clientSecretRef.name | string | `"azure-keyvault-credentials"` |  |
| externalSecrets.secretStore.tenantId | string | `"your-tenant-id"` |  |
| externalSecrets.secretStore.vaultUrl | string | `"https://your-keyvault.vault.azure.net/"` |  |
| extraObjects | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt-prod"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/rewrite-target" | string | `"/"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/ssl-redirect" | string | `"false"` |  |
| ingress.className | string | `"nginx"` |  |
| ingress.enabled | bool | `true` |  |
| ingress.hosts[0].host | string | `"api.yourdomain.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.tls[0].hosts[0] | string | `"api.yourdomain.com"` |  |
| ingress.tls[0].secretName | string | `"stackend-tls"` |  |
| nameOverride | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| stackend.affinity | object | `{}` |  |
| stackend.enabled | bool | `true` |  |
| stackend.env.DATABASE_URL | string | `""` |  |
| stackend.env.DEBUG | string | `"false"` |  |
| stackend.env.ENVIRONMENT | string | `"production"` |  |
| stackend.env.LOG_LEVEL | string | `"INFO"` |  |
| stackend.env.REDIS_URL | string | `""` |  |
| stackend.env.secrets.externalSecretName | string | `"stackend-secrets"` |  |
| stackend.env.secrets.secretStoreClass | string | `"azure-keyvault"` |  |
| stackend.env.secrets.secretStoreName | string | `"azure-keyvault-store"` |  |
| stackend.env.secrets.useExternalSecrets | bool | `true` |  |
| stackend.image.pullPolicy | string | `"IfNotPresent"` |  |
| stackend.image.repository | string | `"your-acr.azurecr.io/stackai/stackend"` |  |
| stackend.image.tag | string | `"latest"` |  |
| stackend.imagePullSecrets | list | `[]` |  |
| stackend.livenessProbe.enabled | bool | `true` |  |
| stackend.livenessProbe.failureThreshold | int | `3` |  |
| stackend.livenessProbe.httpGet.path | string | `"/health"` |  |
| stackend.livenessProbe.httpGet.port | string | `"http"` |  |
| stackend.livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| stackend.livenessProbe.initialDelaySeconds | int | `30` |  |
| stackend.livenessProbe.periodSeconds | int | `10` |  |
| stackend.livenessProbe.successThreshold | int | `1` |  |
| stackend.livenessProbe.timeoutSeconds | int | `5` |  |
| stackend.nodeSelector | object | `{}` |  |
| stackend.podSecurityContext.enabled | bool | `true` |  |
| stackend.podSecurityContext.fsGroup | int | `1000` |  |
| stackend.podSecurityContext.runAsGroup | int | `1000` |  |
| stackend.podSecurityContext.runAsNonRoot | bool | `true` |  |
| stackend.podSecurityContext.runAsUser | int | `1000` |  |
| stackend.readinessProbe.enabled | bool | `true` |  |
| stackend.readinessProbe.failureThreshold | int | `3` |  |
| stackend.readinessProbe.httpGet.path | string | `"/health"` |  |
| stackend.readinessProbe.httpGet.port | string | `"http"` |  |
| stackend.readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| stackend.readinessProbe.initialDelaySeconds | int | `5` |  |
| stackend.readinessProbe.periodSeconds | int | `5` |  |
| stackend.readinessProbe.successThreshold | int | `1` |  |
| stackend.readinessProbe.timeoutSeconds | int | `5` |  |
| stackend.replicaCount | int | `1` |  |
| stackend.resources.limits.cpu | string | `"500m"` |  |
| stackend.resources.limits.memory | string | `"512Mi"` |  |
| stackend.resources.requests.cpu | string | `"100m"` |  |
| stackend.resources.requests.memory | string | `"256Mi"` |  |
| stackend.securityContext.enabled | bool | `true` |  |
| stackend.securityContext.runAsGroup | int | `1000` |  |
| stackend.securityContext.runAsNonRoot | bool | `true` |  |
| stackend.securityContext.runAsUser | int | `1000` |  |
| stackend.service.ports.http | int | `8000` |  |
| stackend.service.type | string | `"ClusterIP"` |  |
| stackend.tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
