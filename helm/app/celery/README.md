# stackai-celery

![Version: 1.1.3](https://img.shields.io/badge/Version-1.1.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.1.3](https://img.shields.io/badge/AppVersion-1.1.3-informational?style=flat-square)

Official StackAI Celery Worker Helm chart.

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
| ingress.hosts[0].host | string | `"celery.yourdomain.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.tls[0].hosts[0] | string | `"celery.yourdomain.com"` |  |
| ingress.tls[0].secretName | string | `"celery-tls"` |  |
| nameOverride | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| worker.affinity | object | `{}` |  |
| worker.enabled | bool | `true` |  |
| worker.env.CELERY_BROKER_URL | string | `"redis://external-redis:6379/0"` |  |
| worker.env.CELERY_RESULT_BACKEND | string | `"redis://external-redis:6379/0"` |  |
| worker.env.secrets.externalSecretName | string | `"celery-secrets"` |  |
| worker.env.secrets.secretStoreClass | string | `"azure-keyvault"` |  |
| worker.env.secrets.secretStoreName | string | `"azure-keyvault-store"` |  |
| worker.env.secrets.useExternalSecrets | bool | `true` |  |
| worker.image.pullPolicy | string | `"IfNotPresent"` |  |
| worker.image.repository | string | `"your-acr.azurecr.io/stackai/celery-worker"` |  |
| worker.image.tag | string | `"latest"` |  |
| worker.livenessProbe.enabled | bool | `true` |  |
| worker.livenessProbe.exec.command[0] | string | `"celery"` |  |
| worker.livenessProbe.exec.command[1] | string | `"-A"` |  |
| worker.livenessProbe.exec.command[2] | string | `"tasks"` |  |
| worker.livenessProbe.exec.command[3] | string | `"inspect"` |  |
| worker.livenessProbe.exec.command[4] | string | `"ping"` |  |
| worker.livenessProbe.failureThreshold | int | `3` |  |
| worker.livenessProbe.initialDelaySeconds | int | `30` |  |
| worker.livenessProbe.periodSeconds | int | `30` |  |
| worker.livenessProbe.successThreshold | int | `1` |  |
| worker.livenessProbe.timeoutSeconds | int | `10` |  |
| worker.nodeSelector | object | `{}` |  |
| worker.podSecurityContext.enabled | bool | `true` |  |
| worker.podSecurityContext.fsGroup | int | `1000` |  |
| worker.podSecurityContext.runAsGroup | int | `1000` |  |
| worker.podSecurityContext.runAsNonRoot | bool | `true` |  |
| worker.podSecurityContext.runAsUser | int | `1000` |  |
| worker.readinessProbe.enabled | bool | `true` |  |
| worker.readinessProbe.exec.command[0] | string | `"celery"` |  |
| worker.readinessProbe.exec.command[1] | string | `"-A"` |  |
| worker.readinessProbe.exec.command[2] | string | `"tasks"` |  |
| worker.readinessProbe.exec.command[3] | string | `"inspect"` |  |
| worker.readinessProbe.exec.command[4] | string | `"ping"` |  |
| worker.readinessProbe.failureThreshold | int | `3` |  |
| worker.readinessProbe.initialDelaySeconds | int | `5` |  |
| worker.readinessProbe.periodSeconds | int | `10` |  |
| worker.readinessProbe.successThreshold | int | `1` |  |
| worker.readinessProbe.timeoutSeconds | int | `5` |  |
| worker.replicaCount | int | `2` |  |
| worker.resources.limits.cpu | string | `"500m"` |  |
| worker.resources.limits.memory | string | `"512Mi"` |  |
| worker.resources.requests.cpu | string | `"200m"` |  |
| worker.resources.requests.memory | string | `"256Mi"` |  |
| worker.securityContext.enabled | bool | `true` |  |
| worker.securityContext.fsGroup | int | `1000` |  |
| worker.securityContext.runAsGroup | int | `1000` |  |
| worker.securityContext.runAsNonRoot | bool | `true` |  |
| worker.securityContext.runAsUser | int | `1000` |  |
| worker.service.ports.http | int | `8000` |  |
| worker.service.type | string | `"ClusterIP"` |  |
| worker.tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
