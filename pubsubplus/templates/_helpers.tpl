{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "solace.name" -}}
  {{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{/*
Create a default fully qualified app name.
We truncate at 53 chars because some Kubernetes name fields are limited (by the DNS naming spec).
*/}}
{{- define "solace.fullname" -}}
  {{- if .Values.fullnameOverride -}}
    {{- .Values.fullnameOverride | trunc 53 | trimSuffix "-" -}}
  {{- else -}}
    {{- $name := default .Chart.Name .Values.nameOverride -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 53 | trimSuffix "-" -}}
  {{- end -}}
{{- end -}}
{{/*
Return the name of the service account to use
*/}}
{{- define "solace.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default ( cat (include "solace.fullname" .) "-sa"  | nospace )  .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Determine the service type based on redundancy
*/}}
{{- define "solace.serviceType" -}}
{{- $serviceType := "enterprise-standalone" -}}
{{- if .Values.solace.redundancy -}}
  {{- $serviceType = "enterprise" -}}
{{- end -}}
{{- $serviceType -}}
{{- end -}}

{{/*
Construct the full broker image name
*/}}
{{- define "solace.image" -}}
{{- if .Values.image.registry -}}
{{ .Values.image.registry }}/{{ .Values.image.repository }}:{{ .Values.image.tag }}
{{- else -}}
{{ .Values.image.repository }}:{{ .Values.image.tag }}
{{- end -}}
{{- end -}}

{{/*
Construct the full insights agent image name
*/}}
{{- define "solace.insightsImage" -}}
{{- if .Values.insights.image.registry -}}
{{ .Values.insights.image.registry }}/{{ .Values.insights.image.repository }}:{{ .Values.insights.image.tag }}
{{- else -}}
{{ .Values.insights.image.repository }}:{{ .Values.insights.image.tag }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "solace.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "solace.labels" -}}
helm.sh/chart: {{ include "solace.chart" . }}
{{ include "solace.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "solace.selectorLabels" -}}
app.kubernetes.io/name: {{ include "solace.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
