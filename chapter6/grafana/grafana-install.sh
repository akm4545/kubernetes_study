#!/usr/bin/env bash
helm install grafana edu/grafana \
# 그라파나 디플로이먼트 삭제를 대비하여 PVC를 통해 데이터 저장
--set persistence.enabled=true \
# PVC 고정 (동적 사용 x)
--set persistence.existingClaim=grafana \
# metalLb를 통해 서비스로 노출
--set service.type=LoadBalancer \
# 그라파나 유저 설정
--set securityContext.runAsUser=1000 \
--set securityContext.runAsGroup=1000 \
# 그라파나 초기 비밀번호 설정
--set adminPassword="admin"