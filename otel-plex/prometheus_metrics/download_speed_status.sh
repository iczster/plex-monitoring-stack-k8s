#!/bin/bash

# ============================================================
# ⚙️ CONFIGURATION INSTRUCTIONS
# ============================================================
# 1. <PATH_TO_YOUR_METRICS>
#    - Replace with the directory where Prometheus .prom files are written
#
# 2. Ensure `networkquality` is available on your system
#    - macOS built-in (Monterey+)
#
# 3. Make executable:
#    chmod +x download_speed_status.sh
#
# ============================================================


# Cron-safe PATH (avoid user-specific paths)
PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH


# Output metric file
METRIC_FILE="<PATH_TO_YOUR_METRICS>/download_speed_status.prom"


# Run network test and extract download speed
PROM_METRIC=$(networkquality -s | grep "Downlink capacity" | awk -F: '{print $2}' | awk '{print $1}')


# Fallback protection (prevents empty metrics)
if [ -z "$PROM_METRIC" ]; then
  PROM_METRIC=0
fi


# Write Prometheus metric
echo "download_speed $PROM_METRIC" > "$METRIC_FILE"
