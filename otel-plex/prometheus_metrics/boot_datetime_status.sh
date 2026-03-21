#!/bin/bash

# ============================================================
# ⚙️ CONFIGURATION INSTRUCTIONS
# ============================================================
# 1. <PATH_TO_YOUR_METRICS>
#    - Replace with the directory where .prom files are written
#    - Example:
#      /opt/prometheus_metrics
#      /Users/youruser/otel-plex/prometheus_metrics
#
# 2. <YOUR_USER_PATH>
#    - Replace with your user-specific PATH entries if required
#    - You can get it by running: echo $PATH
#
# 3. Ensure script is executable:
#    chmod +x boot_datetime_status.sh
#
# ============================================================


# Set PATH (important for cron environments)
PATH=/opt/homebrew/bin:<YOUR_USER_PATH>:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH


# Output metric file location
METRIC_FILE="<PATH_TO_YOUR_METRICS>/boot_date_time.prom"


# Get system boot time (epoch seconds)
PROM_METRIC=$(sysctl -n kern.boottime | awk -F= '{print $2}' | awk -F, '{print $1}' | cut -c2-)


# Write Prometheus metric
echo "system_boot_ms $PROM_METRIC" > "$METRIC_FILE"
