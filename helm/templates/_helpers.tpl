{{/*
Expand the name of the chart.
*/}}
{{- define "stackai-byoc.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "stackai-byoc.fullname" -}}
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
{{- define "stackai-byoc.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "stackai-byoc.labels" -}}
helm.sh/chart: {{ include "stackai-byoc.chart" . }}
{{ include "stackai-byoc.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "stackai-byoc.selectorLabels" -}}
app.kubernetes.io/name: {{ include "stackai-byoc.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "stackai-byoc.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "stackai-byoc.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Azure-specific labels
*/}}
{{- define "stackai-byoc.azureLabels" -}}
azure.workload.identity/use: "true"
{{- end }}

{{/*
Image pull secrets
*/}}
{{- define "stackai-byoc.imagePullSecrets" -}}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- toYaml .Values.global.imagePullSecrets | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Storage class
*/}}
{{- define "stackai-byoc.storageClass" -}}
{{- .Values.global.storageClass | default "managed-csi-premium" }}
{{- end }}

{{/*
Domain name
*/}}
{{- define "stackai-byoc.domain" -}}
{{- .Values.global.domain | default "stackai.local" }}
{{- end }}
