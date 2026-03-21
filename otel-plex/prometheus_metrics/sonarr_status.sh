#!/bin/bash

# ============================================================
# ⚙️ CONFIGURATION INSTRUCTIONS
# ============================================================
# 1. <PATH_TO_YOUR_METRICS>
#    - Replace with the directory where Prometheus .prom files are written
#
# 2. Ensure Sonarr process name matches exactly ("Sonarr")
#    - Verify with: ps aux | grep Sonarr
#
# 3. Make executable:
#    chmod +x sonarr_status.sh
#
# ============================================================


# Cron-safe PATH (minimal + reliable for macOS)
PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH


# Output metric file
METRIC_FILE="<PATH_TO_YOUR_METRICS>/sonarr.prom"


# Check if Sonarr process is running
if pgrep -x "Sonarr" > /dev/null 2>&1; then
    METRIC_VALUE=1
else
    METRIC_VALUE=0
fi


# Write Prometheus metric
echo "sonarr_running $METRIC_VALUE" > "$METRIC_FILE"
