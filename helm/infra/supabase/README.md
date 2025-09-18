# stackai-supabase

![Version: 1.1.1](https://img.shields.io/badge/Version-1.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.1.1](https://img.shields.io/badge/AppVersion-1.1.1-informational?style=flat-square)

Official StackAI Supabase Helm chart.

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
| analytics.enabled | bool | `false` |  |
| auth.additionalDomains | string | `""` |  |
| auth.automountServiceAccountToken | bool | `false` |  |
| auth.db.username | string | `"supabase_auth_admin"` |  |
| auth.disableSignup | bool | `false` |  |
| auth.email.adminEmail | string | `"admin@example.com"` |  |
| auth.email.anonymousUsers | bool | `false` |  |
| auth.email.autoConfirm | bool | `false` |  |
| auth.email.enabled | bool | `false` |  |
| auth.email.existingSecret | string | `""` |  |
| auth.email.host | string | `"supabase-mail"` |  |
| auth.email.password | string | `"fake_mail_password"` |  |
| auth.email.port | int | `2500` |  |
| auth.email.senderName | string | `"fake_sender"` |  |
| auth.email.username | string | `"fake_mail_user"` |  |
| auth.enabled | bool | `true` |  |
| auth.image.repository | string | `"supabase/gotrue"` |  |
| auth.image.tag | string | `"v2.171.0"` |  |
| auth.jwt.adminRoles | string | `"service_role"` |  |
| auth.jwt.aud | string | `"authenticated"` |  |
| auth.jwt.defaultGroup | string | `"authenticated"` |  |
| auth.phone.autoConfirm | bool | `false` |  |
| auth.phone.enabled | bool | `false` |  |
| auth.replicas | int | `1` |  |
| auth.revisionHistoryLimit | int | `10` |  |
| auth.serviceAccountName | string | `""` |  |
| db.external.database | string | `"postgres"` |  |
| db.external.existingSecret | string | `""` |  |
| db.external.host | string | `"192.168.0.1"` |  |
| db.external.password | string | `"password"` |  |
| db.external.port | string | `"5432"` |  |
| db.external.sslmode | string | `"disable"` |  |
| db.external.username | string | `"postgres"` |  |
| db.internal.automountServiceAccountToken | bool | `false` |  |
| db.internal.existingSecret | string | `""` |  |
| db.internal.image.repository | string | `"supabase/postgres"` |  |
| db.internal.image.tag | string | `"15.8.1.069"` |  |
| db.internal.password | string | `"your-super-secret-and-long-postgres-password"` |  |
| db.internal.serviceAccountName | string | `""` |  |
| db.type | string | `"internal"` |  |
| externalURL | string | `"https://example.com"` |  |
| extraObjects | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| functions.automountServiceAccountToken | bool | `false` |  |
| functions.enabled | bool | `true` |  |
| functions.image.repository | string | `"supabase/edge-runtime"` |  |
| functions.image.tag | string | `"v1.67.4"` |  |
| functions.replicas | int | `1` |  |
| functions.revisionHistoryLimit | int | `10` |  |
| functions.serviceAccountName | string | `""` |  |
| functions.verifyJWT | bool | `false` |  |
| jwt.anonKey | string | `"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyAgCiAgICAicm9sZSI6ICJhbm9uIiwKICAgICJpc3MiOiAic3VwYWJhc2UtZGVtbyIsCiAgICAiaWF0IjogMTY0MTc2OTIwMCwKICAgICJleHAiOiAxNzk5NTM1NjAwCn0.dc_X5iR_VP_qT0zsiyj_I_OZ2T9FtRU2BBNWN8Bu4GE"` |  |
| jwt.existingSecret | string | `""` |  |
| jwt.exp | int | `3600` |  |
| jwt.secret | string | `"your-super-secret-jwt-token-with-at-least-32-characters-long"` |  |
| jwt.serviceKey | string | `"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyAgCiAgICAicm9sZSI6ICJzZXJ2aWNlX3JvbGUiLAogICAgImlzcyI6ICJzdXBhYmFzZS1kZW1vIiwKICAgICJpYXQiOiAxNjQxNzY5MjAwLAogICAgImV4cCI6IDE3OTk1MzU2MDAKfQ.DaYlNEoUrrEn2Ig7tqibS-PHK5vgusbcbo7X36XVt4Q"` |  |
| kong.automountServiceAccountToken | bool | `false` |  |
| kong.image.repository | string | `"kong"` |  |
| kong.image.tag | string | `"2.8.1"` |  |
| kong.ingress.annotations | object | `{}` |  |
| kong.ingress.class | string | `""` |  |
| kong.ingress.enabled | bool | `false` |  |
| kong.ingress.hosts | list | `[]` |  |
| kong.ingress.tls.enabled | bool | `false` |  |
| kong.ingress.tls.secret | string | `""` |  |
| kong.replicas | int | `1` |  |
| kong.revisionHistoryLimit | int | `10` |  |
| kong.serviceAccountName | string | `""` |  |
| meta.automountServiceAccountToken | bool | `false` |  |
| meta.enabled | bool | `true` |  |
| meta.image.repository | string | `"supabase/postgres-meta"` |  |
| meta.image.tag | string | `"v0.88.9"` |  |
| meta.replicas | int | `1` |  |
| meta.revisionHistoryLimit | int | `10` |  |
| meta.serviceAccountName | string | `""` |  |
| nameOverride | string | `""` |  |
| realtime.automountServiceAccountToken | bool | `false` |  |
| realtime.db.afterConnectQuery | string | `"SET search_path TO _realtime"` |  |
| realtime.db.encryptionKey | string | `"supabaserealtime"` |  |
| realtime.db.existingSecret | string | `""` |  |
| realtime.db.username | string | `"supabase_admin"` |  |
| realtime.dnsNodes | string | `""` |  |
| realtime.enabled | bool | `true` |  |
| realtime.erlAFlags | string | `"-proto_dist inet_tcp"` |  |
| realtime.existingSecret | string | `""` |  |
| realtime.image.repository | string | `"supabase/realtime"` |  |
| realtime.image.tag | string | `"v2.34.47"` |  |
| realtime.replicas | int | `1` |  |
| realtime.revisionHistoryLimit | int | `10` |  |
| realtime.rlimitNoFile | int | `1000` |  |
| realtime.secretKeyBase | string | `"UpNVntn3cDxHJpq99YMc1T1AQgQpc8kfYTuRgBiYa15BLrx8etQoXz3gZv1/u2oq"` |  |
| realtime.selfHosted | bool | `true` |  |
| realtime.serviceAccountName | string | `""` |  |
| rest.automountServiceAccountToken | bool | `false` |  |
| rest.db.anonRole | string | `"anon"` |  |
| rest.db.schemas | string | `"public,storage,graphql_public"` |  |
| rest.db.username | string | `"authenticator"` |  |
| rest.enabled | bool | `true` |  |
| rest.image.repository | string | `"postgrest/postgrest"` |  |
| rest.image.tag | string | `"v12.2.12"` |  |
| rest.replicas | int | `1` |  |
| rest.revisionHistoryLimit | int | `10` |  |
| rest.serviceAccountName | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| storage.enabled | bool | `false` |  |
| studio.automountServiceAccountToken | bool | `false` |  |
| studio.existingSecret | string | `""` |  |
| studio.image.repository | string | `"supabase/studio"` |  |
| studio.image.tag | string | `"2025.05.05-sha-3c3fe9b"` |  |
| studio.password | string | `"this_password_is_insecure_and_should_be_updated"` |  |
| studio.replicas | int | `1` |  |
| studio.revisionHistoryLimit | int | `10` |  |
| studio.serviceAccountName | string | `""` |  |
| studio.username | string | `"supabase"` |  |
