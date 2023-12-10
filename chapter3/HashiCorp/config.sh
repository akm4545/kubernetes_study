#!/usr/bin/env bash

echo 'alias vi=vim' >> /etc/profile

swapoff -a

sed -i.bak -r 's/(.+ swap .+)/

gg_pkg="packages.cloud.google.com/yum/doc"

cat<<EOF > /etc.yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://${gg_pkg}/yum-key.gpg https://${gg_pkg}/rpm-package-key.gpg
EOF

setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
modprobe br_netfilter

echo "192.168.1.10 m-k8s" >> /etc/hosts
for(( i=1; i<=$1; i++)); do echo "192.168.1.10$i w$i-k8s" >> /etc/hosts; done

cat <<EOF > /etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF