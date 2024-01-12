#!/usr/bin/env bash

# 헬름에서 프로메테우스 설치
#eud 차트 저장소의 prometheus차트 사용
helm install prometheus edu/prometheus \ 
# 푸시게이트웨이 사용하지 않음 [푸시게이트웨이 = 짧은 작업의 메트릭(수집값)을 적재하거나 보안상 내부 접근 제어 폐쇄망 등에서 프로메테우스로 데이터를 보내는데 사용]
--set pushgateway.enabled=false \
# 얼럿매니저 사용지 않음 (젠킨스 빌드 슬랙 알림과 유사한 기능)
--set alertmanager.enabled=false \
# 테인트, 툴러레이션 설정으로 마스터 노드에 설치
--set nodeExporter.tolerations[0].key=node-role.kubernetes.io/master \
--set nodeExporter.tolerations[0].effect=NoSchedule \
--set nodeExporter.tolerations[0].operator=Exists \
# PVC 사용
--set server.persistentVolume.existingClaim="prometheus-server" \
# 프로메테우스 서버의 컨테이너 그룹, 계정
--set server.securityContext.runAsGroup=1000 \
--set server.securityContext.runAsUser=1000 \
# metalLb에게 외부 IP를 할당받기 위해 LoadBalancer로 설정
--set server.service.type="LoadBalancer" \
# 잠긴파일이 생성되면 변경 작업이 실패할 수 있기 때문에 lockfile 생성하지 않도록 성정
--set server.extraFlags[0]="storage.tsdb.no-lockfile"