#!/bin/bash
mkdir /etc/systemd/system/docker.service.d
#printf "[Service]\nExecStartPost=/sbin/iptables -P FORWARD ACCEPT" | tee /etc/systemd/system/docker.service.d/10-iptables.conf
yum install -y docker

cat <<EOF | sudo tee /dev/null #sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
usermod -aG docker ec2-user
systemctl start docker
systemctl enable docker
mkdir -p /proc/sys/net/bridge
echo "1"> /proc/sys/net/bridge/bridge-nf-call-iptables
cat <<EOF | #sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
#EOF
yum install -y kubeadm kubelet kubectl --disableexcludes=kubernetes
sudo hostnamectl set-hostname $(hostname)
sudo mkdir -p /etc/systemd/system/kubelet.service.d
cat << EOF >/etc/systemd/system/kubelet.service.d/20-aws.conf
[Service]
Environment="KUBELET_EXTRA_ARGS=--node-ip=$(hostname -I| awk '{print $1}') --node-labels=node.kubernetes.io/node="
sudo systemctl daemon-reload
sudo systemctl enable kubelet
EOF