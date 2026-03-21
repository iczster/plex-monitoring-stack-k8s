#!/bin/bash

# ============================================================
# ⚙️ CONFIGURATION INSTRUCTIONS
# ============================================================
# 1. <PATH_TO_YOUR_METRICS>
#    - Replace with the directory where .prom files are written
#
# 2. Ensure smctemp is installed (via Homebrew):
#    brew install smctemp
#
# 3. Ensure script is executable:
#    chmod +x cpu_temp_status.sh
#
# ============================================================


# Cron-safe PATH (ensures brew + system binaries are available)
PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH


# Output metric file
METRIC_FILE="<PATH_TO_YOUR_METRICS>/cpu_temp.prom"


# Get CPU temperature (average of 5 samples)
TEMP=$(smctemp -c -n 5)


# Fallback if command fails (prevents empty metrics)
if [ -z "$TEMP" ]; then
  TEMP=0
fi


# Write Prometheus metric
echo "cpu_temp $TEMP" > "$METRIC_FILE"
