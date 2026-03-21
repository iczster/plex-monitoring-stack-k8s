#!/bin/bash

echo "⚠️  STACK CHECK: Checking running pods ..."
kubectl -n plex get pods

echo "############################################################################"
echo "⚠️  STACK CHECK: Checking grafana env vars ..."
kubectl -n plex exec -it deploy/grafana -- printenv | grep RADARR
kubectl -n plex exec -it deploy/grafana -- printenv | grep SONARR

echo "############################################################################"
echo "⚠️  STACK CHECK: Running API checks Grafana Pod > Radarr ..."
kubectl -n plex exec -it deploy/grafana -- \
curl -H "X-Api-Key: YOUR_API_KEY" \
http://YOUR_IP_ADDRESS:7878/api/v3/system/status \
| grep -v isDebug \
| grep -v isAdmin \
| grep -v isDocker \
| grep -v false \
| grep -v true \
| grep -v sqLite \
| grep -v runtime \
| grep -v branch \
| grep -v authentication \
| grep -v migrationVersion \
| grep -v urlBase \
| grep -v mode \
| grep -v packageUpdateMechanism \
| grep -v startupPath \
| grep -v appData

echo "\n############################################################################"
echo "⚠️  STACK CHECK: Running API checks Grafana Pod > Sonarr ..."
kubectl -n plex exec -it deploy/grafana -- \
curl -H "X-Api-Key: YOUR_API_KEY" \
http://YOUR_IP_ADDRESS:8989/api/v3/system/status \
| grep -v isDebug \
| grep -v isAdmin \
| grep -v isDocker \
| grep -v false \
| grep -v true \
| grep -v sqLite \
| grep -v runtime \
| grep -v branch \
| grep -v authentication \
| grep -v migrationVersion \
| grep -v urlBase \
| grep -v mode \
| grep -v packageUpdateMechanism \
| grep -v startupPath \
| grep -v appData

echo "\n############################################################################"
echo "⚠️  STACK CHECK: Checking persistent volume claims ..."
kubectl get pv

echo "############################################################################"
echo "⚠️  STACK CHECK: Checking services ..."
kubectl get services -n plex

echo "############################################################################"
echo "⚠️  STACK CHECK: Checking secrets ..."
kubectl get secrets -n plex

echo "############################################################################"
echo "⚠️  STACK CHECK: Checking config maps ..."
kubectl get configmaps -n plex

echo "############################################################################"
