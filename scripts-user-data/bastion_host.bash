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

# Add required dependencies for the jenkins package
yum install -y java-1.8.0-openjdk
yum install -y daemonize
yum install -y jenkins
mkdir -p /var/lib/jenkins/init.groovy.d
curl https://raw.githubusercontent.com/computerSmokio/rampupv2/main/init.groovy.d/installPlugins.groovy >> /var/lib/jenkins/init.groovy.d/installPlugins.groovy
curl https://raw.githubusercontent.com/computerSmokio/rampupv2/main/init.groovy.d/createAdmin.groovy >> /var/lib/jenkins/init.groovy.d/createAdmin.groovy
systemctl daemon-reload
systemctl start jenkins
systemctl enable jenkins
EOF
hostname chef-infra-server
#Install Chef Infra Server
curl https://artifactory-internal.ps.chef.co/artifactory/omnibus-stable-local/com/getchef/chef-server/14.13.42/amazon/2/chef-server-core-14.13.42-1.el7.x86_64.rpm -o /tmp/chef-server.rpm
sudo rpm -Uvh /tmp/chef-server.rpm
sudo chef-server-ctl reconfigure --chef-license=accept
mkdir -p /root/.chef
sudo chef-server-ctl user-create chefadmin chef admin none@none.com 'abcdefg' --filename /root/.chef/chefadmin.pem
sudo chef-server-ctl org-create rampup 'rampup_org' --association_user chefadmin --filename /home/ec2-user/.ssh/rampuporg-validator.pem
curl https://artifactory-internal.ps.chef.co/artifactory/omnibus-stable-local/com/getchef/chef-workstation/22.2.807/amazon/2/chef-workstation-22.2.807-1.el7.x86_64.rpm -o /tmp/chef-workstation.rpm
rpm -Uvh /tmp/chef-workstation.rpm
cd /home/ec2-user
chef generate repo chef-repo
export COOKBOOKS_DIR="/home/ec2-user/chef-repo/cookbooks"
curl https://raw.githubusercontent.com/computerSmokio/rampupv2/main/config/config.rb -o /root/.chef/config.rb

echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
echo 'export PATH="/opt/chef-workstation/embedded/bin:$PATH"' >> ~/.configuration_file