# stackai-stackweb

![Version: 1.1.4](https://img.shields.io/badge/Version-1.1.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.1.4](https://img.shields.io/badge/AppVersion-1.1.4-informational?style=flat-square)

Official StackAI Stackweb Frontend Helm chart.

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
| ingress.hosts[0].host | string | `"yourdomain.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.tls[0].hosts[0] | string | `"yourdomain.com"` |  |
| ingress.tls[0].secretName | string | `"stackweb-tls"` |  |
| nameOverride | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| stackweb.affinity | object | `{}` |  |
| stackweb.enabled | bool | `true` |  |
| stackweb.env.NEXT_PUBLIC_API_URL | string | `"https://api.yourdomain.com"` |  |
| stackweb.env.NODE_ENV | string | `"production"` |  |
| stackweb.env.secrets.externalSecretName | string | `"stackweb-secrets"` |  |
| stackweb.env.secrets.secretStoreClass | string | `"azure-keyvault"` |  |
| stackweb.env.secrets.secretStoreName | string | `"azure-keyvault-store"` |  |
| stackweb.env.secrets.useExternalSecrets | bool | `true` |  |
| stackweb.image.pullPolicy | string | `"IfNotPresent"` |  |
| stackweb.image.repository | string | `"your-acr.azurecr.io/stackai/stackweb"` |  |
| stackweb.image.tag | string | `"latest"` |  |
| stackweb.livenessProbe.enabled | bool | `true` |  |
| stackweb.livenessProbe.failureThreshold | int | `3` |  |
| stackweb.livenessProbe.httpGet.path | string | `"/"` |  |
| stackweb.livenessProbe.httpGet.port | string | `"http"` |  |
| stackweb.livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| stackweb.livenessProbe.initialDelaySeconds | int | `30` |  |
| stackweb.livenessProbe.periodSeconds | int | `10` |  |
| stackweb.livenessProbe.successThreshold | int | `1` |  |
| stackweb.livenessProbe.timeoutSeconds | int | `5` |  |
| stackweb.nodeSelector | object | `{}` |  |
| stackweb.podSecurityContext.enabled | bool | `true` |  |
| stackweb.podSecurityContext.fsGroup | int | `1000` |  |
| stackweb.podSecurityContext.runAsGroup | int | `1000` |  |
| stackweb.podSecurityContext.runAsNonRoot | bool | `true` |  |
| stackweb.podSecurityContext.runAsUser | int | `1000` |  |
| stackweb.readinessProbe.enabled | bool | `true` |  |
| stackweb.readinessProbe.failureThreshold | int | `3` |  |
| stackweb.readinessProbe.httpGet.path | string | `"/"` |  |
| stackweb.readinessProbe.httpGet.port | string | `"http"` |  |
| stackweb.readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| stackweb.readinessProbe.initialDelaySeconds | int | `5` |  |
| stackweb.readinessProbe.periodSeconds | int | `5` |  |
| stackweb.readinessProbe.successThreshold | int | `1` |  |
| stackweb.readinessProbe.timeoutSeconds | int | `5` |  |
| stackweb.replicaCount | int | `1` |  |
| stackweb.resources.limits.cpu | string | `"500m"` |  |
| stackweb.resources.limits.memory | string | `"512Mi"` |  |
| stackweb.resources.requests.cpu | string | `"100m"` |  |
| stackweb.resources.requests.memory | string | `"256Mi"` |  |
| stackweb.securityContext.enabled | bool | `true` |  |
| stackweb.securityContext.fsGroup | int | `1000` |  |
| stackweb.securityContext.runAsGroup | int | `1000` |  |
| stackweb.securityContext.runAsNonRoot | bool | `true` |  |
| stackweb.securityContext.runAsUser | int | `1000` |  |
| stackweb.service.ports.http | int | `3000` |  |
| stackweb.service.type | string | `"ClusterIP"` |  |
| stackweb.tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
