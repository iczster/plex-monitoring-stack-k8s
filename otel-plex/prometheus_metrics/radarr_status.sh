#!/bin/bash

# ============================================================
# ⚙️ CONFIGURATION INSTRUCTIONS
# ============================================================
# 1. <PATH_TO_YOUR_METRICS>
#    - Replace with the directory where Prometheus .prom files are written
#
# 2. Ensure Radarr process name matches exactly ("Radarr")
#    - Verify with: ps aux | grep Radarr
#
# 3. Make executable:
#    chmod +x radarr_status.sh
#
# ============================================================


# Cron-safe PATH (minimal + reliable for macOS)
PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH


# Output metric file
METRIC_FILE="<PATH_TO_YOUR_METRICS>/radarr.prom"


# Check if Radarr process is running
if pgrep -x "Radarr" > /dev/null 2>&1; then
    METRIC_VALUE=1
else
    METRIC_VALUE=0
fi


# Write Prometheus metric
echo "radarr_running $METRIC_VALUE" > "$METRIC_FILE"
