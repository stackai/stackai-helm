# stackai-celery

![Version: 1.1.0](https://img.shields.io/badge/Version-1.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.1.0](https://img.shields.io/badge/AppVersion-1.1.0-informational?style=flat-square)

Official StackAI Celery Worker and Broker Helm chart.

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
| broker.affinity | object | `{}` |  |
| broker.enabled | bool | `true` |  |
| broker.image.pullPolicy | string | `"IfNotPresent"` |  |
| broker.image.repository | string | `"redis"` |  |
| broker.image.tag | string | `"7.2-alpine"` |  |
| broker.nodeSelector | object | `{}` |  |
| broker.podSecurityContext.enabled | bool | `true` |  |
| broker.podSecurityContext.fsGroup | int | `999` |  |
| broker.podSecurityContext.runAsGroup | int | `999` |  |
| broker.podSecurityContext.runAsNonRoot | bool | `true` |  |
| broker.podSecurityContext.runAsUser | int | `999` |  |
| broker.replicaCount | int | `1` |  |
| broker.resources.limits.cpu | string | `"200m"` |  |
| broker.resources.limits.memory | string | `"256Mi"` |  |
| broker.resources.requests.cpu | string | `"100m"` |  |
| broker.resources.requests.memory | string | `"128Mi"` |  |
| broker.securityContext.enabled | bool | `true` |  |
| broker.securityContext.fsGroup | int | `999` |  |
| broker.securityContext.runAsGroup | int | `999` |  |
| broker.securityContext.runAsNonRoot | bool | `true` |  |
| broker.securityContext.runAsUser | int | `999` |  |
| broker.service.ports.redis | int | `6379` |  |
| broker.service.type | string | `"ClusterIP"` |  |
| broker.tolerations | list | `[]` |  |
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
| nameOverride | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| worker.affinity | object | `{}` |  |
| worker.enabled | bool | `true` |  |
| worker.env.CELERY_BROKER_URL | string | `"redis://celery-broker:6379/0"` |  |
| worker.env.CELERY_RESULT_BACKEND | string | `"redis://celery-broker:6379/0"` |  |
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
| worker.tolerations | list | `[]` |  |

