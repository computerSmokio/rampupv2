#!/bin/bash
echo "${chef_server_ip} chef-infra-server" >> /etc/hosts
mkdir -p /proc/sys/net/bridge
echo "1" > /proc/sys/net/bridge/bridge-nf-call-iptables