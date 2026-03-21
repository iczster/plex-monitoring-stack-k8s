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
#    chmod +x running_tasks_status.sh
#
# ============================================================


# Cron-safe PATH (minimal + reliable for macOS)
PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH


# Output metric file
METRIC_FILE="<PATH_TO_YOUR_METRICS>/running_tasks.prom"

# Input file (powermetrics output)
POWERMETRICS_FILE="<PATH_TO_YOUR_METRICS>/powermetrics.out"


# Extract running tasks block and count entries
RUNNING_TASKS=$(awk '
  /\*\*\* Running tasks \*\*\*/ {flag=1; next}
  /\*\*\*\*/ {flag=0}
  flag && NF
' "$POWERMETRICS_FILE" | grep -vE '^\*\*\*|^Name|^ALL_TASKS' | wc -l)


# Fallback protection
if [ -z "$RUNNING_TASKS" ]; then
  RUNNING_TASKS=0
fi


# Write Prometheus metric
echo "running_tasks $RUNNING_TASKS" > "$METRIC_FILE"
