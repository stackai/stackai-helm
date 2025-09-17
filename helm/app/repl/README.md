# stackai-repl

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Official StackAI Repl API Helm chart.

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
| ingress.hosts[0].host | string | `"repl-api.yourdomain.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.tls[0].hosts[0] | string | `"repl-api.yourdomain.com"` |  |
| ingress.tls[0].secretName | string | `"repl-tls"` |  |
| nameOverride | string | `""` |  |
| repl.affinity | object | `{}` |  |
| repl.enabled | bool | `true` |  |
| repl.env.DATABASE_URL | string | `""` |  |
| repl.env.DEBUG | string | `"false"` |  |
| repl.env.ENVIRONMENT | string | `"production"` |  |
| repl.env.LOG_LEVEL | string | `"INFO"` |  |
| repl.env.REDIS_URL | string | `""` |  |
| repl.env.secrets.externalSecretName | string | `"repl-secrets"` |  |
| repl.env.secrets.secretStoreClass | string | `"azure-keyvault"` |  |
| repl.env.secrets.secretStoreName | string | `"azure-keyvault-store"` |  |
| repl.env.secrets.useExternalSecrets | bool | `true` |  |
| repl.image.pullPolicy | string | `"IfNotPresent"` |  |
| repl.image.repository | string | `"your-acr.azurecr.io/stackai/repl"` |  |
| repl.image.tag | string | `"latest"` |  |
| repl.livenessProbe.enabled | bool | `true` |  |
| repl.livenessProbe.failureThreshold | int | `3` |  |
| repl.livenessProbe.httpGet.path | string | `"/health"` |  |
| repl.livenessProbe.httpGet.port | string | `"http"` |  |
| repl.livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| repl.livenessProbe.initialDelaySeconds | int | `30` |  |
| repl.livenessProbe.periodSeconds | int | `10` |  |
| repl.livenessProbe.successThreshold | int | `1` |  |
| repl.livenessProbe.timeoutSeconds | int | `5` |  |
| repl.nodeSelector | object | `{}` |  |
| repl.podSecurityContext.enabled | bool | `true` |  |
| repl.podSecurityContext.fsGroup | int | `1000` |  |
| repl.podSecurityContext.runAsGroup | int | `1000` |  |
| repl.podSecurityContext.runAsNonRoot | bool | `true` |  |
| repl.podSecurityContext.runAsUser | int | `1000` |  |
| repl.readinessProbe.enabled | bool | `true` |  |
| repl.readinessProbe.failureThreshold | int | `3` |  |
| repl.readinessProbe.httpGet.path | string | `"/health"` |  |
| repl.readinessProbe.httpGet.port | string | `"http"` |  |
| repl.readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| repl.readinessProbe.initialDelaySeconds | int | `5` |  |
| repl.readinessProbe.periodSeconds | int | `5` |  |
| repl.readinessProbe.successThreshold | int | `1` |  |
| repl.readinessProbe.timeoutSeconds | int | `5` |  |
| repl.replicaCount | int | `1` |  |
| repl.resources.limits.cpu | string | `"500m"` |  |
| repl.resources.limits.memory | string | `"512Mi"` |  |
| repl.resources.requests.cpu | string | `"100m"` |  |
| repl.resources.requests.memory | string | `"256Mi"` |  |
| repl.securityContext.enabled | bool | `true` |  |
| repl.securityContext.fsGroup | int | `1000` |  |
| repl.securityContext.runAsGroup | int | `1000` |  |
| repl.securityContext.runAsNonRoot | bool | `true` |  |
| repl.securityContext.runAsUser | int | `1000` |  |
| repl.service.ports.http | int | `8000` |  |
| repl.service.type | string | `"ClusterIP"` |  |
| repl.tolerations | list | `[]` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
