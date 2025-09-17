{{/*
Expand the name of the chart.
*/}}
{{- define "stackweb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "stackweb.fullname" -}}
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
{{- define "stackweb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "stackweb.labels" -}}
helm.sh/chart: {{ include "stackweb.chart" . }}
{{ include "stackweb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "stackweb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "stackweb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "stackweb.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "stackweb.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Stackweb secret name
*/}}
{{- define "stackweb.secret" -}}
  {{- printf "%s-secret" (include "stackweb.fullname" .) | toString -}}
{{- end -}}

{{/*
External secret name
*/}}
{{- define "stackweb.externalSecret" -}}
  {{- if .Values.stackweb.env.secrets.externalSecretName }}
  {{- .Values.stackweb.env.secrets.externalSecretName }}
  {{- else }}
  {{- printf "%s-external-secret" (include "stackweb.fullname" .) }}
  {{- end }}
{{- end -}}

{{/*
Secret store name
*/}}
{{- define "stackweb.secretStore" -}}
  {{- .Values.externalSecrets.secretStore.name -}}
{{- end -}}
