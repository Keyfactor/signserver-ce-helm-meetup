{{/*
Common labels for database
*/}}
{{- define "signserver-ce-helm-meetup.database.labels" -}}
helm.sh/chart: {{ include "signserver-ce-helm-meetup.chart" . }}
{{include "signserver-ce-helm-meetup.database.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for database
*/}}
{{- define "signserver-ce-helm-meetup.database.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.database.host }}
{{- end }}