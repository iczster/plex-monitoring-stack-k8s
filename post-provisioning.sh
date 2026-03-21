#!/bin/bash

# ============================================================
# ⚙️ CONFIGURATION INSTRUCTIONS
# ============================================================
# Before running this script, update the following:
#
# 1. YOUR_IP_ADDRESS
#    - Replace with the IP address of your Radarr/Sonarr host
#    - Examples:
#      - http://YOUR_IP_ADDRESS:7878 (Radarr)
#      - http://YOUR_IP_ADDRESS:8989 (Sonarr)
#
# 2. Grafana Credentials
#    - Default used: admin:admin
#    - If changed, update the curl -u values below
#
# 3. Namespace
#    - Default: plex
#    - Update if deploying to a different namespace
#
# 4. Required Secrets
#    - Ensure these exist before running:
#      - radarr-secret (RADARR_API_KEY)
#      - sonarr-secret (SONARR_API_KEY)
#
# 5. Grafana Deployment
#    - Grafana must already be running before executing this script
#
# ============================================================

set -e

echo "⚠️ Restarting Grafana deployment..."
kubectl rollout restart deployment grafana -n plex
kubectl rollout status deployment grafana -n plex

NAMESPACE="plex"

GRAFANA_POD=$(kubectl -n "$NAMESPACE" get pods -l app=grafana -o jsonpath="{.items[0].metadata.name}")

echo "Using Grafana pod: $GRAFANA_POD"

echo "Waiting for Grafana API..."

until kubectl -n "$NAMESPACE" exec "$GRAFANA_POD" -- curl -s http://localhost:3000/api/health > /dev/null 2>&1
do
  echo "Grafana not ready yet..."
  sleep 3
done

echo "Grafana API ready"


############################################
# RADARR
############################################

RADARR_API_KEY=$(kubectl -n "$NAMESPACE" get secret radarr-secret -o jsonpath="{.data.RADARR_API_KEY}" | base64 --decode)

echo "Configuring Radarr datasource..."

kubectl -n "$NAMESPACE" exec -i "$GRAFANA_POD" -- \
curl -s -u admin:admin \
-H "Content-Type: application/json" \
-X POST \
-d @- http://localhost:3000/api/datasources <<EOF
{
  "uid": "radarr-ds",
  "name": "Radarr",
  "type": "yesoreyeram-infinity-datasource",
  "access": "proxy",
  "url": "http://YOUR_IP_ADDRESS:7878",
  "basicAuth": false,
  "isDefault": false,
  "jsonData": {
    "allowedHosts": [
      "YOUR_IP_ADDRESS:7878",
      "http://YOUR_IP_ADDRESS:7878"
    ],
    "httpHeaderName1": "X-Api-Key"
  },
  "secureJsonData": {
    "httpHeaderValue1": "$RADARR_API_KEY"
  }
}
EOF

echo "Radarr datasource configured"


############################################
# SONARR
############################################

SONARR_API_KEY=$(kubectl -n "$NAMESPACE" get secret sonarr-secret -o jsonpath="{.data.SONARR_API_KEY}" | base64 --decode)

echo "Configuring Sonarr datasource..."

kubectl -n "$NAMESPACE" exec -i "$GRAFANA_POD" -- \
curl -s -u admin:admin \
-H "Content-Type: application/json" \
-X POST \
-d @- http://localhost:3000/api/datasources <<EOF
{
  "uid": "sonarr-ds",
  "name": "Sonarr",
  "type": "yesoreyeram-infinity-datasource",
  "access": "proxy",
  "url": "http://YOUR_IP_ADDRESS:8989",
  "basicAuth": false,
  "isDefault": false,
  "jsonData": {
    "allowedHosts": [
      "YOUR_IP_ADDRESS:8989",
      "http://YOUR_IP_ADDRESS:8989"
    ],
    "httpHeaderName1": "X-Api-Key"
  },
  "secureJsonData": {
    "httpHeaderValue1": "$SONARR_API_KEY"
  }
}
EOF

echo "Sonarr datasource configured"

echo "🎉 Post provisioning complete"
