{{/*
Generate the fullname for resources
*/}}
{{- define "tlstest.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{ .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Chart name
*/}}
{{- define "tlstest.name" -}}
{{ .Chart.Name }}
{{- end -}}

{{/*
Generate selector labels.
*/}}
{{- define "tlstest.labels" }}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
