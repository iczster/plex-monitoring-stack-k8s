# OpenTelemetry + Node Exporter Host Monitoring (macOS)

This setup provides **host level monitoring for a Plex server** using:

- OpenTelemetry Collector (OTEL)
- Node Exporter (Prometheus)
- Custom shell based metrics (.prom files)
- Prometheus (scraping layer)
- Grafana (visualisation)

---

## 📌 Overview

This architecture combines multiple monitoring approaches:

| Component            | Purpose |
|---------------------|--------|
| Node Exporter       | System metrics (CPU, memory, disk, etc.) |
| Textfile Collector  | Custom metrics from shell scripts |
| OpenTelemetry       | Extended host/application telemetry |
| Prometheus          | Scrapes and stores metrics |
| Grafana             | Dashboards and visualisation |

---

## 🧠 How It Works

1. Custom shell scripts generate `.prom` metric files  
2. Node Exporter reads these via `--collector.textfile.directory`  
3. OpenTelemetry runs alongside for additional telemetry  
4. Prometheus scrapes:
   - Node Exporter (`:9100`)
   - OTEL (`:8889` or configured port)  
5. Grafana visualises the data  
6. Fully extensible with scripts to generate additional prom metrics to visualise in Grafana

> NOTE: You will need to download the latest OpenTelemetry collector distrib

---

## ⚙️ Prerequisites

- macOS (Apple Silicon or Intel)  
- Homebrew installed  
- Node Exporter installed via brew  
- OpenTelemetry binary downloaded  
- Prometheus + Grafana running  

---

## 📂 Directory Structure

<PATH_TO_YOUR_OTEL>/
├── otelcol
├── otel-plex-config.yaml
├── prometheus_metrics/
│   ├── *.sh
│   ├── *.prom

---

## 🚀 Startup Script

```bash
#!/bin/bash

# ============================================================
# CONFIGURATION INSTRUCTIONS
# ============================================================
# Replace <PATH_TO_YOUR_OTEL> with your actual directory path
# Ensure node_exporter + otelcol exist
# ============================================================

brew services stop node_exporter

node_exporter --log.level="info"   --collector.textfile.directory=<PATH_TO_YOUR_OTEL>/prometheus_metrics   --web.listen-address=":9100"   > ./node_exporter.log 2>&1 &

<PATH_TO_YOUR_OTEL>/otelcol --config=<PATH_TO_YOUR_OTEL>/otel-plex-config.yaml
```

---

## 📊 Prometheus Scrape Targets

```yaml
- job_name: node_exporter
  static_configs:
    - targets: ["YOUR_IP_ADDRESS:9100"]

- job_name: otel
  static_configs:
    - targets: ["YOUR_IP_ADDRESS:8889"]
```

---

## 🎯 Summary

- Hybrid Prometheus + OTEL monitoring stack  
- Works on macOS  
- Supports custom metrics  
- Easily extendable  
