#!/bin/bash
echo "${chef_server_ip} chef-infra-server" >> /etc/hosts
export KUBECONFIG=/etc/kubernetes/admin.conf
modprobe br_netfilter
sysctl -p /etc/sysctl.conf