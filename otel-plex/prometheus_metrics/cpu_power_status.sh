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
#    chmod +x cpu_power_status.sh
#
# 4. Ensure powermetrics data is being written to the input file
#
# ============================================================


# Cron-safe PATH (minimal but sufficient for macOS + brew)
PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH


# Output metric file
METRIC_FILE="<PATH_TO_YOUR_METRICS>/cpupower.prom"

# Input file (powermetrics output)
INPUT_FILE="<PATH_TO_YOUR_INPUT_FILE>/powermetrics.out"


# Extract CPU power value
PROM_METRIC=$(grep "CPU Power:" "$INPUT_FILE" | awk -F: '{print $2}' | awk '{print $1}')


# Write Prometheus metric
echo "cpu_power $PROM_METRIC" > "$METRIC_FILE"
