#!/bin/bash

# ============================================================
# ⚙️ CONFIGURATION INSTRUCTIONS
# ============================================================
# 1. <PATH_TO_YOUR_METRICS>
#    - Replace with the directory where Prometheus .prom files are written
#
# 2. Ensure vm_stat is available (default on macOS)
#
# 3. Make executable:
#    chmod +x pages_active_status.sh
#
# ============================================================


# Cron-safe PATH (minimal + reliable for macOS)
PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH


# Output metric file
METRIC_FILE="<PATH_TO_YOUR_METRICS>/pages_active.prom"


# Extract active pages from vm_stat
PROM_METRIC=$(/usr/bin/vm_stat | grep "Pages active:" | awk '{sub(/\.$/, ""); print $3}')


# Fallback protection (prevents empty metrics)
if [ -z "$PROM_METRIC" ]; then
  PROM_METRIC=0
fi


# Write Prometheus metric
echo "total_pages_active $PROM_METRIC" > "$METRIC_FILE"
