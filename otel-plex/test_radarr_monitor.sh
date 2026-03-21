#!/bin/bash
# -------------------------------
# macOS Radarr monitoring test
# -------------------------------

# 1️⃣ Check if Radarr is running
echo "Checking if Radarr is running..."
if pgrep -x "Radarr" > /dev/null; then
    echo "✅ Radarr process found"
else
    echo "❌ Radarr process NOT found"
fi

# 2️⃣ Check Collector metrics directly
echo ""
echo "Checking OpenTelemetry Collector metrics..."
METRICS=$(curl -s http://localhost:8889/metrics | grep 'Radarr')
if [[ -n "$METRICS" ]]; then
    echo "✅ Collector is exposing Radarr metrics:"
    echo "$METRICS"
else
    echo "❌ No metrics for Radarr found on Collector"
fi

# 3️⃣ Check Prometheus for the process metric
echo ""
echo "Checking Prometheus for recording rule output..."
PROM_QUERY=$(curl -s 'http://localhost:9090/api/v1/query?query=process_radarr_running' | jq '.data.result')
if [[ "$PROM_QUERY" != "[]" ]]; then
    echo "✅ Prometheus shows process_radarr_running metric:"
    echo "$PROM_QUERY"
else
    echo "❌ Prometheus has no data for process_radarr_running yet"
    echo " - Make sure Prometheus is scraping Collector at localhost:8889"
    echo " - Make sure recording rule is loaded and evaluated"
fi

