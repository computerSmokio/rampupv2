#!/bin/bash
yum -y update
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import http://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum -y upgrade
yum install git -y
cat <<EOF | sudo tee /etc/yum.repos.d/epelfordaemonize.repo
[daemonize]
baseurl=https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/
gpgcheck=no
enabled=yes
EOF
# Install Docker
yum install -y docker
systemctl start docker
systemctl enable docker
# Add required dependencies for the jenkins package
yum install -y java-1.8.0-openjdk
yum install -y daemonize
yum install -y jenkins
mkdir -p /var/lib/jenkins/init.groovy.d
curl https://raw.githubusercontent.com/computerSmokio/rampupv2/main/init.groovy.d/installPlugins.groovy >> /var/lib/jenkins/init.groovy.d/installPlugins.groovy
curl https://raw.githubusercontent.com/computerSmokio/rampupv2/main/init.groovy.d/createAdmin.groovy >> /var/lib/jenkins/init.groovy.d/createAdmin.groovy
usermod -aG docker jenkins
#Install Chef Infra Server
git clone https://github.com/computerSmokio/chef-repo.git /var/lib/jenkins/chef-repo
chown -R jenkins /var/lib/jenkins/chef-repo
export KNIFE_HOME="/var/lib/jenkins/chef-repo/.chef"
cat <<EOF | tee /etc/profile.d/variables.sh
export KNIFE_HOME="/var/lib/jenkins/chef-repo/.chef"
EOF
systemctl daemon-reload
systemctl --no-block start jenkins
systemctl enable jenkins
curl https://artifactory-internal.ps.chef.co/artifactory/omnibus-stable-local/com/getchef/chef-workstation/22.2.807/amazon/2/chef-workstation-22.2.807-1.el7.x86_64.rpm -o /tmp/chef-workstation.rpm
rpm -Uvh /tmp/chef-workstation.rpm
echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
echo 'export PATH="/opt/chef-workstation/embedded/bin:$PATH"' >> ~/.configuration_file
knife ssl fetch
#Install Terraform
sudo curl https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip -o /tmp/terraform.zip && sudo unzip /tmp/terraform.zip -d /usr/bin