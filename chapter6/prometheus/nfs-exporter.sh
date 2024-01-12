#!/usr/bin/env bash
nfsdir=/nfs-shared/$1
# 인자 검사
if [ $# -eq 0 ]; then
    echo "usage: nfs-exporter.sh <name>"; exit 0
fi
# -d = 디렉토리면 참
if [[ ! -d $nfsdir ]]; then
# -p = 해당 경로의 디렉토리를 모두 생성
    mkdir -p $nfsdir
    # nfs 서버 설정
    echo "$nfsdir 192.168.1.0/24(rw,sync,no_root_squash)" >> /etc/exports
    if [[ $(systemctl is-enabled nfs) -eq "disabled" ]]; then
        systemctl enable nfs
    fi
        systemctl restart nfs
fi