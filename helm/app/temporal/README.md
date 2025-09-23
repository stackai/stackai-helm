# stackai-temporal

![Version: 1.1.3](https://img.shields.io/badge/Version-1.1.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.1.3](https://img.shields.io/badge/AppVersion-1.1.3-informational?style=flat-square)

Official StackAI Temporal Workflow Engine Helm chart.

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
| ingress.hosts[0].host | string | `"temporal.yourdomain.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.tls[0].hosts[0] | string | `"temporal.yourdomain.com"` |  |
| ingress.tls[0].secretName | string | `"temporal-tls"` |  |
| nameOverride | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| temporal.affinity | object | `{}` |  |
| temporal.enabled | bool | `true` |  |
| temporal.env.DB | string | `"postgres12"` |  |
| temporal.env.DB_PORT | string | `"5432"` |  |
| temporal.env.ENABLE_ES | string | `"false"` |  |
| temporal.env.ES_SEEDS | string | `""` |  |
| temporal.env.ES_VERSION | string | `"v7"` |  |
| temporal.env.POSTGRES_PWD | string | `""` |  |
| temporal.env.POSTGRES_SEEDS | string | `""` |  |
| temporal.env.POSTGRES_USER | string | `"temporal"` |  |
| temporal.env.SKIP_SCHEMA_SETUP | string | `"true"` |  |
| temporal.env.secrets.externalSecretName | string | `"temporal-secrets"` |  |
| temporal.env.secrets.secretStoreClass | string | `"azure-keyvault"` |  |
| temporal.env.secrets.secretStoreName | string | `"azure-keyvault-store"` |  |
| temporal.env.secrets.useExternalSecrets | bool | `true` |  |
| temporal.image.pullPolicy | string | `"IfNotPresent"` |  |
| temporal.image.repository | string | `"temporalio/auto-setup"` |  |
| temporal.image.tag | string | `"1.24.2"` |  |
| temporal.livenessProbe.enabled | bool | `true` |  |
| temporal.livenessProbe.failureThreshold | int | `3` |  |
| temporal.livenessProbe.httpGet.path | string | `"/"` |  |
| temporal.livenessProbe.httpGet.port | string | `"web"` |  |
| temporal.livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| temporal.livenessProbe.initialDelaySeconds | int | `60` |  |
| temporal.livenessProbe.periodSeconds | int | `30` |  |
| temporal.livenessProbe.successThreshold | int | `1` |  |
| temporal.livenessProbe.timeoutSeconds | int | `10` |  |
| temporal.nodeSelector | object | `{}` |  |
| temporal.podSecurityContext.enabled | bool | `true` |  |
| temporal.podSecurityContext.fsGroup | int | `1000` |  |
| temporal.podSecurityContext.runAsGroup | int | `1000` |  |
| temporal.podSecurityContext.runAsNonRoot | bool | `true` |  |
| temporal.podSecurityContext.runAsUser | int | `1000` |  |
| temporal.readinessProbe.enabled | bool | `true` |  |
| temporal.readinessProbe.failureThreshold | int | `3` |  |
| temporal.readinessProbe.httpGet.path | string | `"/"` |  |
| temporal.readinessProbe.httpGet.port | string | `"web"` |  |
| temporal.readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| temporal.readinessProbe.initialDelaySeconds | int | `30` |  |
| temporal.readinessProbe.periodSeconds | int | `10` |  |
| temporal.readinessProbe.successThreshold | int | `1` |  |
| temporal.readinessProbe.timeoutSeconds | int | `5` |  |
| temporal.replicaCount | int | `1` |  |
| temporal.resources.limits.cpu | string | `"1000m"` |  |
| temporal.resources.limits.memory | string | `"1Gi"` |  |
| temporal.resources.requests.cpu | string | `"200m"` |  |
| temporal.resources.requests.memory | string | `"512Mi"` |  |
| temporal.securityContext.enabled | bool | `true` |  |
| temporal.securityContext.fsGroup | int | `1000` |  |
| temporal.securityContext.runAsGroup | int | `1000` |  |
| temporal.securityContext.runAsNonRoot | bool | `true` |  |
| temporal.securityContext.runAsUser | int | `1000` |  |
| temporal.service.ports.frontend | int | `7233` |  |
| temporal.service.ports.web | int | `8080` |  |
| temporal.service.type | string | `"ClusterIP"` |  |
| temporal.tolerations | list | `[]` |  |
| temporalWeb.affinity | object | `{}` |  |
| temporalWeb.enabled | bool | `true` |  |
| temporalWeb.env.TEMPORAL_ADDRESS | string | `"temporal-server:7233"` |  |
| temporalWeb.env.TEMPORAL_CORS_ORIGINS | string | `"http://localhost:3000"` |  |
| temporalWeb.image.pullPolicy | string | `"IfNotPresent"` |  |
| temporalWeb.image.repository | string | `"temporalio/ui"` |  |
| temporalWeb.image.tag | string | `"2.29.0"` |  |
| temporalWeb.livenessProbe.enabled | bool | `true` |  |
| temporalWeb.livenessProbe.failureThreshold | int | `3` |  |
| temporalWeb.livenessProbe.httpGet.path | string | `"/"` |  |
| temporalWeb.livenessProbe.httpGet.port | string | `"http"` |  |
| temporalWeb.livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| temporalWeb.livenessProbe.initialDelaySeconds | int | `30` |  |
| temporalWeb.livenessProbe.periodSeconds | int | `30` |  |
| temporalWeb.livenessProbe.successThreshold | int | `1` |  |
| temporalWeb.livenessProbe.timeoutSeconds | int | `10` |  |
| temporalWeb.nodeSelector | object | `{}` |  |
| temporalWeb.podSecurityContext.enabled | bool | `false` |  |
| temporalWeb.readinessProbe.enabled | bool | `true` |  |
| temporalWeb.readinessProbe.failureThreshold | int | `3` |  |
| temporalWeb.readinessProbe.httpGet.path | string | `"/"` |  |
| temporalWeb.readinessProbe.httpGet.port | string | `"http"` |  |
| temporalWeb.readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| temporalWeb.readinessProbe.initialDelaySeconds | int | `10` |  |
| temporalWeb.readinessProbe.periodSeconds | int | `10` |  |
| temporalWeb.readinessProbe.successThreshold | int | `1` |  |
| temporalWeb.readinessProbe.timeoutSeconds | int | `5` |  |
| temporalWeb.replicaCount | int | `1` |  |
| temporalWeb.resources.limits.cpu | string | `"200m"` |  |
| temporalWeb.resources.limits.memory | string | `"256Mi"` |  |
| temporalWeb.resources.requests.cpu | string | `"100m"` |  |
| temporalWeb.resources.requests.memory | string | `"128Mi"` |  |
| temporalWeb.securityContext.enabled | bool | `false` |  |
| temporalWeb.service.ports.http | int | `8088` |  |
| temporalWeb.service.type | string | `"ClusterIP"` |  |
| temporalWeb.tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
