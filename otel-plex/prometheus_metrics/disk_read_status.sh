#!/bin/bash

# ============================================================
# ⚙️ CONFIGURATION INSTRUCTIONS
# ============================================================
# 1. <PATH_TO_YOUR_METRICS>
#    - Replace with the directory where .prom files are written
#
# 2. <PATH_TO_YOUR_INPUT_FILE>
#    - Replace with the location of your powermetrics output file
#
# 3. Ensure script is executable:
#    chmod +x disk_read_status.sh
#
# 4. Ensure powermetrics output is being updated regularly
#
# ============================================================


# Cron-safe PATH
PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH


# Output metric file
METRIC_FILE="<PATH_TO_YOUR_METRICS>/disk_read.prom"

# Input file (powermetrics output)
INPUT_FILE="<PATH_TO_YOUR_INPUT_FILE>/powermetrics.out"


# Extract disk read IOPS (per second)
PROM_METRIC=$(grep "read:" "$INPUT_FILE" | awk -F: '{print $2}' | awk '{print $1}')


# Fallback if metric is empty
if [ -z "$PROM_METRIC" ]; then
  PROM_METRIC=0
fi


# Write Prometheus metric
echo "disk_read_total_iops_per_second $PROM_METRIC" > "$METRIC_FILE"
