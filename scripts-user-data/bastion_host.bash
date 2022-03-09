wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import http://pkg.jenkins.io/redhat-stable/jenkins.io.key
printf ""
cat <<EOF | sudo tee /etc/yum.repos.d/epelfordaemonize.repo
[daemonize]
baseurl=https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/
gpgcheck=no
enabled=yes
EOF
yum -y upgrade
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