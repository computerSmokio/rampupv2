wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum upgrade
# Add required dependencies for the jenkins package
yum install java-11-openjdk
yum install jenkins
curl https://raw.githubusercontent.com/computerSmokio/rampupv2/main/init.groovy.d/installPlugins.groovy >> /var/jenkins/init.groovy.d/installPlugins.groovy
curl https://raw.githubusercontent.com/computerSmokio/rampupv2/main/init.groovy.d/createAdmin.groovy >> /var/jenkins/init.groovy.d/createAdmin.groovy
systemctl daemon-reload
systemctl start jenkins
systemctl enable jenkins
