mkdir /etc/systemd/system/docker.service.d
printf "[Service]\nExecStartPost=/sbin/iptables -P FORWARD ACCEPT" | tee /etc/systemd/system/docker.service.d/10-iptables.conf
yum install -y docker

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
yum install -y kubelet kubeadm kubectl
mkdir /etc/systemd/system/kubelet.service.d
printf '[Service]\nEnvironment="KUBELET_EXTRA_ARGS=--node-ip=10.0.0.11"' | tee /etc/systemd/system/kubelet.service.d/20-aws.conf
kubeadm init --token-ttl 0 --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem
systemctl enable kubelet
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config