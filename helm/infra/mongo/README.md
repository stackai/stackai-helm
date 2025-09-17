# stackai-mongodb

![Version: 1.1.0](https://img.shields.io/badge/Version-1.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.1.0](https://img.shields.io/badge/AppVersion-1.1.0-informational?style=flat-square)

Official StackAI MongoDB Helm chart.

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
| extraObjects | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| mongodb.affinity | object | `{}` |  |
| mongodb.auth.enabled | bool | `true` |  |
| mongodb.auth.existingSecret | string | `""` |  |
| mongodb.auth.rootDatabase | string | `"admin"` |  |
| mongodb.auth.rootPassword | string | `"mongodb123"` |  |
| mongodb.auth.rootUsername | string | `"admin"` |  |
| mongodb.configuration | string | `"storage:\n  dbPath: /data/db\n  journal:\n    enabled: true\n  wiredTiger:\n    engineConfig:\n      cacheSizeGB: 1\nsystemLog:\n  destination: file\n  logAppend: true\n  path: /var/log/mongodb/mongod.log\nnet:\n  port: 27017\n  bindIpAll: true\n"` |  |
| mongodb.enabled | bool | `true` |  |
| mongodb.image.pullPolicy | string | `"IfNotPresent"` |  |
| mongodb.image.repository | string | `"mongo"` |  |
| mongodb.image.tag | float | `7` |  |
| mongodb.livenessProbe.enabled | bool | `true` |  |
| mongodb.livenessProbe.failureThreshold | int | `3` |  |
| mongodb.livenessProbe.initialDelaySeconds | int | `30` |  |
| mongodb.livenessProbe.periodSeconds | int | `10` |  |
| mongodb.livenessProbe.successThreshold | int | `1` |  |
| mongodb.livenessProbe.timeoutSeconds | int | `5` |  |
| mongodb.nodeSelector | object | `{}` |  |
| mongodb.persistence.accessMode | string | `"ReadWriteOnce"` |  |
| mongodb.persistence.enabled | bool | `true` |  |
| mongodb.persistence.size | string | `"10Gi"` |  |
| mongodb.persistence.storageClass | string | `""` |  |
| mongodb.podSecurityContext.enabled | bool | `true` |  |
| mongodb.podSecurityContext.fsGroup | int | `999` |  |
| mongodb.podSecurityContext.runAsGroup | int | `999` |  |
| mongodb.podSecurityContext.runAsNonRoot | bool | `true` |  |
| mongodb.podSecurityContext.runAsUser | int | `999` |  |
| mongodb.readinessProbe.enabled | bool | `true` |  |
| mongodb.readinessProbe.failureThreshold | int | `3` |  |
| mongodb.readinessProbe.initialDelaySeconds | int | `5` |  |
| mongodb.readinessProbe.periodSeconds | int | `5` |  |
| mongodb.readinessProbe.successThreshold | int | `1` |  |
| mongodb.readinessProbe.timeoutSeconds | int | `5` |  |
| mongodb.replicaCount | int | `1` |  |
| mongodb.resources.limits.cpu | string | `"500m"` |  |
| mongodb.resources.limits.memory | string | `"512Mi"` |  |
| mongodb.resources.requests.cpu | string | `"100m"` |  |
| mongodb.resources.requests.memory | string | `"256Mi"` |  |
| mongodb.securityContext.enabled | bool | `true` |  |
| mongodb.securityContext.fsGroup | int | `999` |  |
| mongodb.securityContext.runAsGroup | int | `999` |  |
| mongodb.securityContext.runAsUser | int | `999` |  |
| mongodb.service.ports.mongodb | int | `27017` |  |
| mongodb.service.type | string | `"ClusterIP"` |  |
| mongodb.tolerations | list | `[]` |  |
| nameOverride | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |

