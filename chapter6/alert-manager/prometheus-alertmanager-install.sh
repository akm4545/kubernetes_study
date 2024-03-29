#!/usr/bin/env bash
helm upgrade prometheus edu/prometheus \
--set pushgateway.enabled=false \
--set nodeExporter.tolerations[0].key=node-role.kubernetes.io/master \
--set nodeExporter.tolerations[0].effect=NoSchedule \
--set nodeExporter.tolerations[0].operator=Exists \
--set alertmanager.persistentVolume.existingClaim="prometheus-alertmanager" \
--set server.persistentVolume.existingClaim="prometheus-server" \
--set server.securityContext.runAsGroup=1000 \
--set server.securityContext.runAsUser=1000 \
--set server.service.type="LoadBalancer" \
--set server.baseURL="http://192.168.1.12" \
--set server.service.loadBalancerIP="102.168.1.12" \
--set server.extraFlags[0]="storage.tsdb.no-lockfile" \
# 컨피그맵 덮어쓰기 prometheus-notifier-config 해야하는거 아닌가
--set alertmanager.configMapOverrideName=notifier-config \
--set alertmanger.securityContext.runAsGroup=1000 \
--set alertmanger.securityContext.runAsUser=1000 \
--set alertmanager.service.type="LoadBalancer" \
--set alertmanager.service.loadBalancerIP="192.168.1.14" \
--set alertmanager.baseURL="http://192.168.1.14" \
-f ~/_Book_k8sInfra/ch6/6.5.1/values.yaml