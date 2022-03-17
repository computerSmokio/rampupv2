#!/bin/bash




#mkdir /etc/systemd/system/docker.service.d
#printf "[Service]\nExecStartPost=/sbin/iptables -P FORWARD ACCEPT" | tee /etc/systemd/system/docker.service.d/10-iptables.conf
#yum install -y docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}

usermod -aG docker ec2-user
systemctl start docker
systemctl enable docker
#cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
#EOF
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
mkdir /etc/systemd/system/kubelet.service.d
#cat <<EOF | tee /etc/systemd/system/kubelet.service.d/20-aws.conf
[Service]
Environment="KUBELET_EXTRA_ARGS=--node-ip=$(hostname -I| awk '{print $1}')"
#EOF
mkdir -p /proc/sys/net/bridge
echo "1"> /proc/sys/net/bridge/bridge-nf-call-iptables
kubeadm init --token-ttl 0 --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem --pod-network-cidr=10.244.0.0/16
systemctl enable kubelet
mkdir -p /home/ec2-user/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/ec2-user/.kube/config
sudo chown ec2-user /home/ec2-user/.kube/config
curl https://raw.githubusercontent.com/computerSmokio/rampupv2/main/kubernetes_related/frontend_deployment.yaml -o /home/ec2-user/frontend_deployment.yaml
EOF