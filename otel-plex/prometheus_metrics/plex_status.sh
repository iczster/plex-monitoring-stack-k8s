#!/bin/bash

# ============================================================
# ⚙️ CONFIGURATION INSTRUCTIONS
# ============================================================
# 1. <PATH_TO_YOUR_METRICS>
#    - Replace with the directory where Prometheus .prom files are written
#
# 2. Ensure Plex process name matches exactly ("Plex Media Server")
#    - Verify with: ps aux | grep "Plex Media Server"
#
# 3. Make executable:
#    chmod +x plex_status.sh
#
# ============================================================


# Cron-safe PATH (minimal + reliable for macOS)
PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH


# Output metric file
METRIC_FILE="<PATH_TO_YOUR_METRICS>/plex.prom"


# Check if Plex Media Server is running
if pgrep -x "Plex Media Server" > /dev/null 2>&1; then
    METRIC_VALUE=1
else
    METRIC_VALUE=0
fi


# Write Prometheus metric
echo "plex_running $METRIC_VALUE" > "$METRIC_FILE"
