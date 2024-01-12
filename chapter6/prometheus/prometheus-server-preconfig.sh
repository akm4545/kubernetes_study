#!/usr/bin/env bash

echo "[Step 1/4] Task [Check helm status]"
# -e 파일이 있으면 참
# 헬름 체크
if [ ! -e "/usr/local/bin/helm" ]; then
    echo "[Step 1/4] helm not found"
    exit 1
fi
echo "[Step 1/4] ok"

echo "[Step 2/4] Task [Check MetalLB status]"
# metallb 설치 파악 [2> /dev/null = 에러가 뜨면 해당 에러는 버림 ]
namespace=$(kubectl get namespace metallb-system -o jsonpath={.metadata.name} 2> /dev/null)
if [ "$namespace" == "" ]; then
    echo "[Step 2/4] metallb not found"
    exit 1
fi
echo "[Step 2/4] ok"

nfsdir=/nfs_shared/prometheus/server
echo "[Step 3/4] Task [Create NFS directory for prometheus-server]"
if [ ! -e "$nfsdir" ]; then
    # nfs-exporter.sh로 값 전달
    ~/_Book_k8sInfra/ch6/6.2.1/nfs-exporter.sh prometheus/server
    # 위의 스크립트로 만든 nfs 서버 권한 처리
    chown 1000:1000 $nfsdir
    echo "$nfsdir created"
    echo "[Step 3/4] Successfully completed"
else
    echo "[Step 3/4] failed: $nfsdir already exists"
    exit 1
fi

# prometheus-server 체크
echo "[Step 4/4] Task [Create PV,PVC for prometheus-server]"
pvc=$(kubectl get pvc prometheus-server -o jsonpath={.metadata.name} 2> /dev/null)
if [ "$pvc" == "" ]; then
    # pv,pvc 생성
    kubectl apply -f ~/_Book_k8sInfra/ch6/6.2.1/prometheus-server-volume.yaml
    echo "[Step 4/4] Successfully completed"
else
    echo "[Step 4/4] failed: prometheus-server pv,pvc already exist"
fi