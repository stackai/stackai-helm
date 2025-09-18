# postgres

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 15.8](https://img.shields.io/badge/AppVersion-15.8-informational?style=flat-square)

A lightweight PostgreSQL database for Temporal

**Homepage:** <https://www.postgresql.org/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| StackAI Team | <team@stackai.dev> |  |

## Source Code

* <https://github.com/postgres/postgres>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| postgres.database.name | string | `"temporal"` |  |
| postgres.database.password | string | `"temporal-dev-password"` |  |
| postgres.database.superuser | string | `"postgres"` |  |
| postgres.database.superuserPassword | string | `"postgres-dev-password"` |  |
| postgres.database.username | string | `"temporal"` |  |
| postgres.enabled | bool | `true` |  |
| postgres.env.POSTGRES_DB | string | `"temporal"` |  |
| postgres.env.POSTGRES_INITDB_ARGS | string | `"--encoding=UTF-8 --lc-collate=C --lc-ctype=C"` |  |
| postgres.env.POSTGRES_PASSWORD | string | `"temporal-dev-password"` |  |
| postgres.env.POSTGRES_USER | string | `"temporal"` |  |
| postgres.image.pullPolicy | string | `"IfNotPresent"` |  |
| postgres.image.repository | string | `"postgres"` |  |
| postgres.image.tag | string | `"15.8"` |  |
| postgres.livenessProbe.enabled | bool | `true` |  |
| postgres.livenessProbe.exec.command[0] | string | `"/bin/sh"` |  |
| postgres.livenessProbe.exec.command[1] | string | `"-c"` |  |
| postgres.livenessProbe.exec.command[2] | string | `"exec pg_isready -U \"$POSTGRES_USER\" -d \"$POSTGRES_DB\" -h 127.0.0.1 -p 5432"` |  |
| postgres.livenessProbe.failureThreshold | int | `3` |  |
| postgres.livenessProbe.initialDelaySeconds | int | `30` |  |
| postgres.livenessProbe.periodSeconds | int | `10` |  |
| postgres.livenessProbe.successThreshold | int | `1` |  |
| postgres.livenessProbe.timeoutSeconds | int | `5` |  |
| postgres.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| postgres.persistence.enabled | bool | `true` |  |
| postgres.persistence.size | string | `"5Gi"` |  |
| postgres.persistence.storageClass | string | `""` |  |
| postgres.podSecurityContext.enabled | bool | `true` |  |
| postgres.podSecurityContext.fsGroup | int | `999` |  |
| postgres.podSecurityContext.runAsGroup | int | `999` |  |
| postgres.podSecurityContext.runAsNonRoot | bool | `true` |  |
| postgres.podSecurityContext.runAsUser | int | `999` |  |
| postgres.readinessProbe.enabled | bool | `true` |  |
| postgres.readinessProbe.exec.command[0] | string | `"/bin/sh"` |  |
| postgres.readinessProbe.exec.command[1] | string | `"-c"` |  |
| postgres.readinessProbe.exec.command[2] | string | `"exec pg_isready -U \"$POSTGRES_USER\" -d \"$POSTGRES_DB\" -h 127.0.0.1 -p 5432"` |  |
| postgres.readinessProbe.failureThreshold | int | `3` |  |
| postgres.readinessProbe.initialDelaySeconds | int | `5` |  |
| postgres.readinessProbe.periodSeconds | int | `10` |  |
| postgres.readinessProbe.successThreshold | int | `1` |  |
| postgres.readinessProbe.timeoutSeconds | int | `5` |  |
| postgres.resources.limits.cpu | string | `"500m"` |  |
| postgres.resources.limits.memory | string | `"512Mi"` |  |
| postgres.resources.requests.cpu | string | `"100m"` |  |
| postgres.resources.requests.memory | string | `"256Mi"` |  |
| postgres.securityContext.enabled | bool | `true` |  |
| postgres.securityContext.fsGroup | int | `999` |  |
| postgres.securityContext.runAsGroup | int | `999` |  |
| postgres.securityContext.runAsNonRoot | bool | `true` |  |
| postgres.securityContext.runAsUser | int | `999` |  |
| postgres.service.port | int | `5432` |  |
| postgres.service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |
