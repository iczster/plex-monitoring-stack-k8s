# Plex Monitoring Overview

Effective monitoring is essential for maintaining a healthy and high-performing Plex ecosystem. Whether you are running a single Plex Media Server at home or managing a more complex, multi-host setup, having visibility into performance, reliability, and usage patterns helps ensure smooth media streaming for all users.

The Plex Monitoring Stack provides a comprehensive set of dashboards designed to give you insights into server health, host performance, long-term metrics, and media usage trends. These dashboards draw data from a combination of Prometheus metrics, node exporters, cAdvisor, OpenTelemetry collectors, and custom monitoring scripts (including MacOS ARM-tested exporters), all presented in a clear and actionable way.

This document provides an overview of the available dashboards, the reference stack components, and the types of metrics they expose.

> **Note:** Sample JSON payloads have also been generated to build example screenshots for the dashboards. These can be used to reproduce or validate the visualisations without requiring live data.

---

## 🧱 Reference Stack Overview

The following versions represent the validated reference stack used during the creation and testing of the Plex Monitoring dashboards. These serve as a baseline for compatibility, expected behaviour, and performance.

| Component             | Version     | Notes |
|----------------------|-------------|-------|
| **Grafana**          | 12.3.0      | Dashboard visualisation and alerting |
| **MacOS**            | 26.1.0      | Host OS used for testing; includes custom ARM monitoring scripts |
| **Prometheus**       | 3.7.3       | Metrics scraping, storage, and alerting |
| **cAdvisor**         | 0.49.1      | Container-level metrics for Docker workloads |
| **OpenTelemetry**    | 1.46.0      | Collector pipeline for metrics/telemetry processing |
| **Docker Desktop**   | 4.31.0      | Docker engine and UI used in the monitoring stack |
| **Docker Engine**    | 29.0.1      | Container runtime version |
| **kubectl**          | 1.34.1      | Used for Kubernetes-based deployments (when applicable) |

These versions represent a known-good configuration, though more recent versions may be compatible with minor dashboard or metric schema differences.

---

## 📊 Dashboards Overview

---

### 1. Plex Server Health

**Purpose:**  
Provides high-level visibility into the overall health and performance of the Plex server and associated services.

**Key Metrics Include:**
- Plex version information  
- Server uptime and availability  
- Stack availability status  
- Currently running streams  
- Stream performance metrics  
- Library statistics (counts, growth, sizes)  
- Host metrics (CPU, memory, disk, network, etc.)

**Dashboard Previews:**  
### Plex Overview
![Plex Server Health](../images/plex-server-health.png)
![Stream Count Info](../images/stream-count-info.png)
![Playing Sessions Info](../images/playing-sessions-info.png)
![Series Info](../images/series-info.png)
![Movie Info](../images/movie-info.png)
![Media Count Info](../images/media-count-info.png)
![Library Info](../images/library-info.png)
![Library Storage Info](../images/library-storage-info.png)
![Library Duration Info](../images/library-duration-info.png)
![Resource Utilisation Info](../images/resource-utilisation-info.png)
---

### 2. Plex Host Metrics

**Purpose:**  
Offers deep dive system level metrics across all hosts running components of the Plex Monitoring stack.  
This dashboard includes *30-day metric retention* for historical trend analysis.

**Key Metrics Include:**
- CPU utilisation and load averages  
- Memory usage trends  
- Network throughput and errors  
- Disk usage, I/O, filesystem health  
- Running processes and resource consumers  
- Temperature and environmental metrics  
- Node exporter metrics for the monitoring host  
- Custom Prometheus metrics for MacOS (tested on ARM)

**Dashboard Preview:**  
![Plex Host Metrics](../images/plex-host-metrics.png)

---

### 3. Plex Insights

**Purpose:**  
Provides detailed analytics on how your Plex media is being consumed.  
Ideal for understanding viewing patterns, popular content, and system demand.

**Key Metrics Include:**
- Stream counts (current and historical)  
- Media consumption trends  
- Transcode vs. direct play statistics  
- Viewer/session analytics  
- Peak usage times  
- Playback performance metrics  

**Dashboard Preview:**  
![Plex Insights](../images/plex-insights.png)

---

## 📁 Images Directory

Please ensure all dashboard images are placed in the `./images` folder relative to this documentation file so the Markdown previews resolve correctly.


