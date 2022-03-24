#!/bin/bash
echo "${chef_server_ip} chef-infra-server" >> /etc/hosts
export KUBECONFIG=/etc/kubernetes/admin.conf
cat <<EOF | tee /etc/profile.d/variables.sh
export KUBECONFIG=/etc/kubernetes/admin.conf
EOF
modprobe br_netfilter
sysctl -p /etc/sysctl.conf