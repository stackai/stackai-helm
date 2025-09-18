# stackai-redis

![Version: 1.1.1](https://img.shields.io/badge/Version-1.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 7.3.1](https://img.shields.io/badge/AppVersion-7.3.1-informational?style=flat-square)

Official StackAI Redis Helm chart.

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
| nameOverride | string | `""` |  |
| redis.affinity | object | `{}` |  |
| redis.auth.enabled | bool | `false` |  |
| redis.auth.existingSecret | string | `""` |  |
| redis.auth.password | string | `""` |  |
| redis.configuration | string | `"# Redis configuration file\nsave 900 1\nsave 300 10\nsave 60 10000\nstop-writes-on-bgsave-error yes\nrdbcompression yes\nrdbchecksum yes\ndbfilename dump.rdb\ndir /data\nappendonly yes\nappendfsync everysec\nno-appendfsync-on-rewrite no\nauto-aof-rewrite-percentage 100\nauto-aof-rewrite-min-size 64mb\naof-load-truncated yes\naof-use-rdb-preamble yes\nmaxmemory 256mb\nmaxmemory-policy allkeys-lru\n"` |  |
| redis.enabled | bool | `true` |  |
| redis.image.pullPolicy | string | `"IfNotPresent"` |  |
| redis.image.repository | string | `"redis"` |  |
| redis.image.tag | string | `"7.2-alpine"` |  |
| redis.livenessProbe.enabled | bool | `true` |  |
| redis.livenessProbe.failureThreshold | int | `3` |  |
| redis.livenessProbe.initialDelaySeconds | int | `30` |  |
| redis.livenessProbe.periodSeconds | int | `10` |  |
| redis.livenessProbe.successThreshold | int | `1` |  |
| redis.livenessProbe.timeoutSeconds | int | `5` |  |
| redis.nodeSelector | object | `{}` |  |
| redis.persistence.accessMode | string | `"ReadWriteOnce"` |  |
| redis.persistence.enabled | bool | `true` |  |
| redis.persistence.size | string | `"5Gi"` |  |
| redis.persistence.storageClass | string | `""` |  |
| redis.podSecurityContext.enabled | bool | `true` |  |
| redis.podSecurityContext.fsGroup | int | `999` |  |
| redis.podSecurityContext.runAsGroup | int | `999` |  |
| redis.podSecurityContext.runAsNonRoot | bool | `true` |  |
| redis.podSecurityContext.runAsUser | int | `999` |  |
| redis.readinessProbe.enabled | bool | `true` |  |
| redis.readinessProbe.failureThreshold | int | `3` |  |
| redis.readinessProbe.initialDelaySeconds | int | `5` |  |
| redis.readinessProbe.periodSeconds | int | `5` |  |
| redis.readinessProbe.successThreshold | int | `1` |  |
| redis.readinessProbe.timeoutSeconds | int | `5` |  |
| redis.replicaCount | int | `1` |  |
| redis.resources.limits.cpu | string | `"200m"` |  |
| redis.resources.limits.memory | string | `"256Mi"` |  |
| redis.resources.requests.cpu | string | `"100m"` |  |
| redis.resources.requests.memory | string | `"128Mi"` |  |
| redis.securityContext.enabled | bool | `true` |  |
| redis.securityContext.fsGroup | int | `999` |  |
| redis.securityContext.runAsGroup | int | `999` |  |
| redis.securityContext.runAsUser | int | `999` |  |
| redis.service.ports.redis | int | `6379` |  |
| redis.service.type | string | `"ClusterIP"` |  |
| redis.tolerations | list | `[]` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
