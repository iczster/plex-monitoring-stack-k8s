#!/bin/bash

# ============================================================
# ⚙️ CONFIGURATION INSTRUCTIONS
# ============================================================
# 1. <PATH_TO_YOUR_METRICS>
#    - Replace with the directory where Prometheus .prom files are written
#
# 2. Ensure powermetrics.out exists in this directory
#    - This script does NOT generate it
#
# 3. Make executable:
#    chmod +x gpu_power_status.sh
#
# ============================================================


# Cron-safe PATH (minimal + reliable for macOS)
PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH


# Output metric file
METRIC_FILE="<PATH_TO_YOUR_METRICS>/gpupower.prom"

# Input file (powermetrics output)
POWERMETRICS_FILE="<PATH_TO_YOUR_METRICS>/powermetrics.out"


# Extract GPU power value
PROM_METRIC=$(grep "GPU Power:" "$POWERMETRICS_FILE" | head -n 1 | awk -F: '{print $2}' | awk '{print $1}')


# Fallback protection (prevents empty metrics)
if [ -z "$PROM_METRIC" ]; then
  PROM_METRIC=0
fi


# Write Prometheus metric
echo "gpu_power $PROM_METRIC" > "$METRIC_FILE"
