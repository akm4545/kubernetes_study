#!/usr/bin/env bash

yum install epel-release -y
yum install vim-enhanced -y
yum install git -y

yum install docker -y && systemctl enable --now docker

yum install kubectl-$1 kubelet-$1 kubeadm-$1 -y
systemctl enable --now kubelet

if [ $2 = 'Main' ]; then
 git clone https://github.com/sysneet4admin/_Book_k8sInfra.git
 mv /home/vagrant/_Book_k8sInfra $HOME
 find $HOME/_Book_k8sInfra/ -regex ".*\.\(sh\)" -exec chmod 700 {} \;
fi