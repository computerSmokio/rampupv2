#!/bin/bash
echo "${chef_server_ip} chef-infra-server" >> /etc/hosts
export KUBECONFIG=/etc/kubernetes/admin.conf
modprobe br_netfilter
echo 'net.bridge.bridge-nf-call-iptables=1' | sudo tee -a /etc/sysctl.conf
sysctl -p /etc/sysctl.conf