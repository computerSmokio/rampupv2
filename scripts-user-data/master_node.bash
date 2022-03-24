#!/bin/bash
echo "${chef_server_ip} chef-infra-server" >> /etc/hosts
modprobe br_netfilter
sysctl -p /etc/sysctl.conf