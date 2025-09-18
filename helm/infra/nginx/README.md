# stackai-nginx-ingress

![Version: 1.1.1](https://img.shields.io/badge/Version-1.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.10.1](https://img.shields.io/badge/AppVersion-1.10.1-informational?style=flat-square)

Official StackAI Nginx Ingress Controller Helm chart.

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
| controller.affinity | object | `{}` |  |
| controller.config.add-forwarded-for-headers | string | `"true"` |  |
| controller.config.client-body-buffer-size | string | `"128k"` |  |
| controller.config.client-header-buffer-size | string | `"1k"` |  |
| controller.config.enable-access-log-for-default-backend | string | `"true"` |  |
| controller.config.large-client-header-buffers | string | `"4 4k"` |  |
| controller.config.proxy-buffer-size | string | `"4k"` |  |
| controller.config.proxy-buffers | string | `"4 32k"` |  |
| controller.config.proxy-busy-buffers-size | string | `"8k"` |  |
| controller.config.proxy-connect-timeout | string | `"60"` |  |
| controller.config.proxy-read-timeout | string | `"60"` |  |
| controller.config.proxy-send-timeout | string | `"60"` |  |
| controller.config.rate-limit | string | `"100"` |  |
| controller.config.rate-limit-window | string | `"1m"` |  |
| controller.config.ssl-ciphers | string | `"ECDHE-RSA-AES128-GCM-SHA256,ECDHE-RSA-AES256-GCM-SHA384,ECDHE-RSA-AES128-SHA,ECDHE-RSA-AES256-SHA,ECDHE-RSA-AES128-SHA256,ECDHE-RSA-AES256-SHA384,ECDHE-RSA-AES128-GCM-SHA256,ECDHE-RSA-AES256-GCM-SHA384,ECDHE-RSA-AES128-SHA256,ECDHE-RSA-AES256-SHA384"` |  |
| controller.config.ssl-protocols | string | `"TLSv1.2 TLSv1.3"` |  |
| controller.enabled | bool | `true` |  |
| controller.image.pullPolicy | string | `"IfNotPresent"` |  |
| controller.image.repository | string | `"registry.k8s.io/ingress-nginx/controller"` |  |
| controller.image.tag | string | `"v1.9.4"` |  |
| controller.ingressClass | string | `"nginx"` |  |
| controller.ingressClassResource.controllerValue | string | `"k8s.io/ingress-nginx"` |  |
| controller.ingressClassResource.default | bool | `true` |  |
| controller.ingressClassResource.enabled | bool | `true` |  |
| controller.ingressClassResource.name | string | `"nginx"` |  |
| controller.livenessProbe.enabled | bool | `true` |  |
| controller.livenessProbe.failureThreshold | int | `5` |  |
| controller.livenessProbe.httpGet.path | string | `"/healthz"` |  |
| controller.livenessProbe.httpGet.port | int | `10254` |  |
| controller.livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| controller.livenessProbe.initialDelaySeconds | int | `10` |  |
| controller.livenessProbe.periodSeconds | int | `10` |  |
| controller.livenessProbe.successThreshold | int | `1` |  |
| controller.livenessProbe.timeoutSeconds | int | `1` |  |
| controller.nodeSelector | object | `{}` |  |
| controller.podSecurityContext.enabled | bool | `true` |  |
| controller.podSecurityContext.fsGroup | int | `65534` |  |
| controller.podSecurityContext.runAsGroup | int | `101` |  |
| controller.podSecurityContext.runAsNonRoot | bool | `true` |  |
| controller.podSecurityContext.runAsUser | int | `101` |  |
| controller.readinessProbe.enabled | bool | `true` |  |
| controller.readinessProbe.failureThreshold | int | `3` |  |
| controller.readinessProbe.httpGet.path | string | `"/healthz"` |  |
| controller.readinessProbe.httpGet.port | int | `10254` |  |
| controller.readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| controller.readinessProbe.initialDelaySeconds | int | `0` |  |
| controller.readinessProbe.periodSeconds | int | `5` |  |
| controller.readinessProbe.successThreshold | int | `1` |  |
| controller.readinessProbe.timeoutSeconds | int | `1` |  |
| controller.replicaCount | int | `1` |  |
| controller.resources.limits.cpu | string | `"500m"` |  |
| controller.resources.limits.memory | string | `"512Mi"` |  |
| controller.resources.requests.cpu | string | `"100m"` |  |
| controller.resources.requests.memory | string | `"128Mi"` |  |
| controller.securityContext.enabled | bool | `true` |  |
| controller.securityContext.fsGroup | int | `65534` |  |
| controller.securityContext.runAsGroup | int | `101` |  |
| controller.securityContext.runAsNonRoot | bool | `true` |  |
| controller.securityContext.runAsUser | int | `101` |  |
| controller.service.annotations."service.beta.kubernetes.io/azure-load-balancer-internal" | string | `"true"` |  |
| controller.service.annotations."service.beta.kubernetes.io/azure-load-balancer-internal-subnet" | string | `"subnet-name"` |  |
| controller.service.ports.http | int | `80` |  |
| controller.service.ports.https | int | `443` |  |
| controller.service.type | string | `"LoadBalancer"` |  |
| controller.tolerations | list | `[]` |  |
| defaultBackend.enabled | bool | `true` |  |
| defaultBackend.image.pullPolicy | string | `"IfNotPresent"` |  |
| defaultBackend.image.repository | string | `"registry.k8s.io/defaultbackend-amd64"` |  |
| defaultBackend.image.tag | string | `"1.5"` |  |
| defaultBackend.podSecurityContext.enabled | bool | `true` |  |
| defaultBackend.podSecurityContext.fsGroup | int | `65534` |  |
| defaultBackend.podSecurityContext.runAsGroup | int | `65534` |  |
| defaultBackend.podSecurityContext.runAsNonRoot | bool | `true` |  |
| defaultBackend.podSecurityContext.runAsUser | int | `65534` |  |
| defaultBackend.resources.limits.cpu | string | `"50m"` |  |
| defaultBackend.resources.limits.memory | string | `"64Mi"` |  |
| defaultBackend.resources.requests.cpu | string | `"10m"` |  |
| defaultBackend.resources.requests.memory | string | `"32Mi"` |  |
| defaultBackend.securityContext.enabled | bool | `true` |  |
| defaultBackend.securityContext.fsGroup | int | `65534` |  |
| defaultBackend.securityContext.runAsGroup | int | `65534` |  |
| defaultBackend.securityContext.runAsNonRoot | bool | `true` |  |
| defaultBackend.securityContext.runAsUser | int | `65534` |  |
| extraObjects | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| nameOverride | string | `""` |  |
| podDisruptionBudget.enabled | bool | `false` |  |
| podDisruptionBudget.minAvailable | int | `1` |  |
| rbac.create | bool | `true` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| serviceRouting.enabled | bool | `true` |  |
| serviceRouting.services.argocd.enabled | bool | `true` |  |
| serviceRouting.services.argocd.path | string | `"/argocd"` |  |
| serviceRouting.services.argocd.port | int | `80` |  |
| serviceRouting.services.argocd.service | string | `"argocd-server"` |  |
| serviceRouting.services.mongodb.enabled | bool | `true` |  |
| serviceRouting.services.mongodb.path | string | `"/mongodb"` |  |
| serviceRouting.services.mongodb.port | int | `27017` |  |
| serviceRouting.services.mongodb.service | string | `"mongodb"` |  |
| serviceRouting.services.postgres.enabled | bool | `true` |  |
| serviceRouting.services.postgres.path | string | `"/postgres"` |  |
| serviceRouting.services.postgres.port | int | `5432` |  |
| serviceRouting.services.postgres.service | string | `"postgres"` |  |
| serviceRouting.services.redis.enabled | bool | `true` |  |
| serviceRouting.services.redis.path | string | `"/redis"` |  |
| serviceRouting.services.redis.port | int | `6379` |  |
| serviceRouting.services.redis.service | string | `"redis"` |  |
| serviceRouting.services.supabase.api.path | string | `"/supabase/rest"` |  |
| serviceRouting.services.supabase.api.port | int | `8000` |  |
| serviceRouting.services.supabase.api.service | string | `"supabase-kong"` |  |
| serviceRouting.services.supabase.auth.path | string | `"/supabase/auth"` |  |
| serviceRouting.services.supabase.auth.port | int | `8000` |  |
| serviceRouting.services.supabase.auth.service | string | `"supabase-kong"` |  |
| serviceRouting.services.supabase.enabled | bool | `true` |  |
| serviceRouting.services.supabase.functions.path | string | `"/supabase/functions"` |  |
| serviceRouting.services.supabase.functions.port | int | `8000` |  |
| serviceRouting.services.supabase.functions.service | string | `"supabase-kong"` |  |
| serviceRouting.services.supabase.graphql.path | string | `"/supabase/graphql"` |  |
| serviceRouting.services.supabase.graphql.port | int | `8000` |  |
| serviceRouting.services.supabase.graphql.service | string | `"supabase-kong"` |  |
| serviceRouting.services.supabase.realtime.path | string | `"/supabase/realtime"` |  |
| serviceRouting.services.supabase.realtime.port | int | `8000` |  |
| serviceRouting.services.supabase.realtime.service | string | `"supabase-kong"` |  |
| serviceRouting.services.supabase.storage.path | string | `"/supabase/storage"` |  |
| serviceRouting.services.supabase.storage.port | int | `8000` |  |
| serviceRouting.services.supabase.storage.service | string | `"supabase-kong"` |  |
| serviceRouting.services.supabase.studio.path | string | `"/supabase/studio"` |  |
| serviceRouting.services.supabase.studio.port | int | `3000` |  |
| serviceRouting.services.supabase.studio.service | string | `"supabase-studio"` |  |
| serviceRouting.services.temporal.enabled | bool | `true` |  |
| serviceRouting.services.temporal.path | string | `"/temporal"` |  |
| serviceRouting.services.temporal.port | int | `8088` |  |
| serviceRouting.services.temporal.service | string | `"temporal-web"` |  |
| serviceRouting.services.unstructured.enabled | bool | `true` |  |
| serviceRouting.services.unstructured.path | string | `"/unstructured"` |  |
| serviceRouting.services.unstructured.port | int | `8000` |  |
| serviceRouting.services.unstructured.service | string | `"unstructured"` |  |
| serviceRouting.services.weaviate.enabled | bool | `true` |  |
| serviceRouting.services.weaviate.path | string | `"/weaviate"` |  |
| serviceRouting.services.weaviate.port | int | `8080` |  |
| serviceRouting.services.weaviate.service | string | `"weaviate"` |  |
