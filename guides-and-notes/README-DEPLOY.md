# 🚀 Deployment Apply Order & Validation Checks

This section outlines the exact sequence required to deploy the full monitoring stack cleanly, including required validation checks and endpoint verification.

## 1. Apply Namespace

```bash
kubectl apply -f namespace.yaml
```

## 2. Apply Pre Provisioning Resources

> NOTE: Built into deployments not needed. Left for reference

All StorageClasses, PersistentVolumes, Radarr/Sonarr secrets, Plex secrets, and supporting objects are included in:

```bash
kubectl apply -f pre-provisioning.yaml
```

## 3. Validation Checks

✔️ Check StorageClass
```bash
kubectl get storageclass
```

✔️ Check PersistentVolumes

```bash
kubectl get pv
```

✔️ Check Secrets in Namespace ```plex```

```bash
kubectl get secrets -n plex
```
Expected Example Output

```pgsql
NAME                   PROVISIONER            AGE
grafana-hostpath       docker.io/hostpath     12s

NAME                CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     AGE
grafana-pv          5Gi        RWO            Retain           Available  10s
prometheus-pv       20Gi       RWO            Retain           Available  10s
```

Secrets:

```pgsql
NAME                  TYPE     DATA   AGE
radarr-secret         Opaque   1      12s
sonarr-secret         Opaque   1      12s
```

## 4. Deployment Build Order

A. Deploy cAdvisor

```bash
kubectl apply -f cadvisor.yaml
```

B. Deploy Prometheus

```bash
kubectl apply -f prometheus.yaml
```
C. Deploy Plex Exporter

```bash
kubectl apply -f plex-exporter.yaml
```

D. Deploy Grafana
> **NOTE:** Prometheus must be running before Grafana is deployed.

```bash
1. pre-provisioning-grafana.sh # Dashboard configmaps
2. kubectl apply -f grafana.yaml # Deploy Grafana
```

## 5. Run Post Provisioning Script

Once all pods are running:

```bash
./post-provisioning.sh
```

> **NOTE:** ⚠️ This will need to be run everytime a rollout or redeployment of Grafana occurs

This script will:

* Import / update all dashboards
* Trigger a Grafana rollout restart
* Patch Infinity datasources (Radarr + Sonarr) with:
    * Updated X-API-Key headers
    * Updated knownHosts

## 6. Verify All Services via k8s LoadBalancer

cAdvisor

```arduino
http://localhost:30903
```

Prometheus

```arduino
http://localhost:30901
```

Plex Exporter

```arduino
http://localhost:30900
```

Grafana

```arduino
http://localhost:30902
```

## 7. Confirm Pod Status

```bash
kubectl get pods -n plex -o wide
```

Expecte:

```sql
cadvisor-xxxxx                  Running
prometheus-xxxxx                Running
prometheus-plex-exporter        Running
grafana-xxxxx                   Running
```

## 8. Final Verification

* Log into Grafana
* Dashboards should appear under Plex-Monitoring
* Data Sources show:
    * Prometheus = OK
    * Radarr = OK
    * Sonarr = OK
* Panels successfully load metrics (Streams, Downloads, System, Library Stats, etc.)


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
