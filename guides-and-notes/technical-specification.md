# Technical Specification Plex Monitoring Stack (Kubernetes)

## 1. Introduction

This document provides a detailed technical specification for the Plex monitoring stack deployed on Kubernetes (Docker Desktop). It outlines the architecture, components, configuration, networking model, storage approach, and operational considerations.

---

## 2. System Overview

The solution provides observability for a Plex environment using:

- Metrics collection (Prometheus)
- Visualisation (Grafana)
- Infrastructure monitoring (cAdvisor, kube-state-metrics)
- Application monitoring (Plex exporter)
- External service integration (Sonarr, Radarr APIs)

The system is deployed into a dedicated Kubernetes namespace:

`plex`

---

## 3. Architecture

Kubernetes Cluster (Docker Desktop / KIND)

- Prometheus (Metrics Collection)
- Grafana (Visualisation)
- cAdvisor (Container Metrics)
- Plex Exporter (Application Metrics)
- kube-state-metrics (Cluster Metrics)

External Systems:
- Sonarr (API)
- Radarr (API)

---

## 4. Components

### Prometheus
- Scrape interval: 15s
- Retention: 30d
- Size limit: 5GB

### Grafana
- Provisioned via ConfigMaps
- Uses Infinity datasource plugin

### Plex Exporter
- Exposes /metrics endpoint

### cAdvisor
- Container resource metrics

### kube-state-metrics
- Kubernetes state metrics

---

## 5. Networking

Use:
http://prometheus-service:30901

Not:
http://prometheus-service:9091

Docker Desktop uses Envoy LoadBalancer (kindccm containers)

---

## 6. Storage

- Uses container filesystem (Docker volume)
- Retention limited to 5GB

---

## 7. Deployment Order

1. Create namespace
2. Deploy Prometheus
3. Deploy exporters
4. Create Grafana ConfigMaps
5. Deploy Grafana
6. Run post provisioning script

---

## 8. Grafana Dashboard Provisioning Example

```bash
kubectl create configmap grafana-dashboards \
  --from-file=plex-host-metrics.json="Plex Host Metrics.json" \
  --from-file=plex-server-health.json="Plex Server Health.json" \
  -n plex
```
Must be created `BEFORE` Grafana starts

---

## 9. Post Provisioning

Updates the X-API config for Radarr/Sonarr connectivity to work via grafana custom datasources

```bash
./post-provisioning.sh
```
---

## 10. Observability

- Plex metrics (Health, Statistics and Insights)
- Container metrics
- Kubernetes metrics
- External APIs

---

# 11. Final Verification

* Log into Grafana
* Dashboards should appear under Plex Monitoring
* Data Sources show:
    * Prometheus = OK
    * Radarr = OK
    * Sonarr = OK
* Panels successfully load metrics (Streams, Downloads, System, Library Stats, etc.)

```text
                 +-----------------------------+
                 |       Your Mac / Host       |
                 | (Docker Desktop + Kubernetes)|
                 +-----------------------------+
                               |
                     NodePort access (external)
                               |
   -----------------------------------------------------------------------
   |                  Namespace: plex (K8s)                              |
   -----------------------------------------------------------------------
   |                                                                     |
   |  +----------------+     +----------------+     +------------+       |
   |  | Plex Exporter  |     |  Prometheus    |     |  Grafana   |       |
   |  |  Pod           |     |  Pod           |     |  Pod       |       |
   |  | ContainerPort: |     | ContainerPort: |     | Container  |       |
   |  | 9000           |     | 9090           |     | Port: 3000 |       |
   |  +----------------+     +----------------+     +------------+       |
   |   | NodePort 30900      | NodePort 30901       | NodePort 30902     |
   |   |                     |                      |                    |
   |   | Scrapes metrics     | Stores metrics       | Dashboards         |deploy
   |   |                     |                      |                    |
   |                                                                     |
   |                         +------------+                              |
   |                         |  cAdvisor  |                              |  
   |                         |  Pod       |                              |
   |                         | Container  |                              |
   |                         | Port: 8080 |                              |
   |                         +------------+                              |
   |                         NodePort 30903                              |
   -----------------------------------------------------------------------
```
---
## 12. Limitations

- Docker Desktop networking quirks
- No persistent external storage
- LoadBalancer is emulated

---

## 13. Summary

- Fully working monitoring stack
- ConfigMap driven provisioning
- Docker Desktop compatible
