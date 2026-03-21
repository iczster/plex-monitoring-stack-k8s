# Pre provision the dashboard configmaps prior to deployment

cd ./dashboards
kubectl create configmap grafana-dashboards \
  --from-file=plex-host-metrics.json="Plex-Host-Metrics.json" \
  --from-file=plex-server-health.json="Plex-Server-Health.json" \
  --from-file=plex-insights.json="Plex-Insights.json" \
  -n plex
echo "Config Maps Created"

