{{/*
Expand the name of the chart.
*/}}
{{- define "repl.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "repl.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "repl.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "repl.labels" -}}
helm.sh/chart: {{ include "repl.chart" . }}
{{ include "repl.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "repl.selectorLabels" -}}
app.kubernetes.io/name: {{ include "repl.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "repl.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "repl.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Repl secret name
*/}}
{{- define "repl.secret" -}}
  {{- printf "%s-secret" (include "repl.fullname" .) | toString -}}
{{- end -}}

{{/*
External secret name
*/}}
{{- define "repl.externalSecret" -}}
  {{- if .Values.repl.env.secrets.externalSecretName }}
  {{- .Values.repl.env.secrets.externalSecretName }}
  {{- else }}
  {{- printf "%s-external-secret" (include "repl.fullname" .) }}
  {{- end }}
{{- end -}}

{{/*
Secret store name
*/}}
{{- define "repl.secretStore" -}}
  {{- .Values.externalSecrets.secretStore.name -}}
{{- end -}}
