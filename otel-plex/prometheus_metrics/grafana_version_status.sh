#!/bin/bash

# ============================================================
# ⚙️ CONFIGURATION INSTRUCTIONS
# ============================================================
# 1. <PATH_TO_YOUR_METRICS>
#    - Replace with the directory where Prometheus .prom files are written
#
# 2. <GRAFANA_URL>
#    - Replace with your Grafana URL (e.g. http://YOUR_IP_ADDRESS:3000)
#
# 3. Ensure Grafana API is accessible from this host
#
# 4. Make executable:
#    chmod +x grafana_version_status.sh
#
# ============================================================


# Cron-safe PATH (minimal + reliable)
PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH


# Output metric file
METRIC_FILE="<PATH_TO_YOUR_METRICS>/grafana_version.prom"

# Grafana API endpoint
GRAFANA_URL="<GRAFANA_URL>/api/health"


# Fetch Grafana version
PROM_METRIC=$(curl -s "$GRAFANA_URL" | grep "version" | awk -F: '{print $2}' | awk -F\" '{print $2}')


# Fallback protection
if [ -z "$PROM_METRIC" ]; then
  PROM_METRIC="unknown"
fi


# Write Prometheus metric (label-based metric)
echo "grafana_info{grafana_installed_version=\"$PROM_METRIC\"} 1" > "$METRIC_FILE"
