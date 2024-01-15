#!/usr/bin/env bash

# 디텍토리가 인자로 들어왔는지 체크
nfsdir=/nfs_shared/$1
if [ $# -eq 0 ]; then
    echo "usage: nfs-exporter.sh <name>"; exit 0
fi

# 디렉토리 생성 및 nfs 설정
if [[ ! -d $nfsdir ]]; then
    mkdir -p $nfsdir
    echo "$nfsdir 192.168.1.0/24(rw,sync,no_root_squash)" >> /etc/exports
    if [[ $(systemctl is-enabled nfs) -eq "disabled" ]]; then
        systemctl enable nfs
    fi
        systemctl restart nfs
fi