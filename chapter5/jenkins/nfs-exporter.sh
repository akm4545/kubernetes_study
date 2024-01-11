#젠킨스를 구동시킬 파드에 PV를 마운트 하기 위해서 (파드 재시작 시 데이터 삭제를 막기 위해)
#nfs를 설정

nfsdir=/nfs_shared/$1
if [ $# -eq 0 ]; then
    echo "usage: nfs-exporter.sh <name>"; exit 0
fi

if [[ ! -d $nfsdir ]]; then
    mkdir -p $nfsdir
    echo "$nfsdir 192.168.1.0/24(rw, sync, no_root_squash)" >> /etx/exports
    if [[ $(systemctl is-enabled nfs) -eq "disabled" ]]l then
        systemctl enable nfs
    fi
     systemctl restart nfs
fi