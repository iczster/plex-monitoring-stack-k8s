#!/bin/bash

# ============================================================
# ⚙️ CONFIGURATION INSTRUCTIONS
# ============================================================
# 1. <PATH_TO_YOUR_METRICS>
#    - Replace with your prometheus_metrics directory
#
# 2. Ensure powermetrics.out exists in that directory
#    - This script does NOT generate it
#
# ============================================================


# Cron-safe PATH
PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH


# Metric output file
METRIC_FILE="<PATH_TO_YOUR_METRICS>/disk_write.prom"

# Powermetrics source file (same dir as your original script)
POWERMETRICS_FILE="<PATH_TO_YOUR_METRICS>/powermetrics.out"


# Extract metric (same logic as your original)
PROM_METRIC=$(cat "$POWERMETRICS_FILE" | grep "write:" | awk -F: '{print $2}' | cut -c2- | awk '{print $1}')


# Write metric
echo "disk_write_total_iops_per_second $PROM_METRIC" > "$METRIC_FILE"
