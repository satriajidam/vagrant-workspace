#!/bin/bash

# intended for Ubuntu 64-bit

# ensure running as root
if [ "$(id -u)" != "0" ]; then
  exec sudo "$0" "$@" 
fi

# add required repositories
add-apt-repository ppa:git-core/ppa -y
add-apt-repository ppa:webupd8team/java -y
curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
bash nodesource_setup.sh && rm nodesource_setup.sh
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add -
echo deb https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list

# install prerequisites
apt-get update
apt-get -y install git tree python-pip build-essential libssl-dev unzip

# upgrade pip
pip install --upgrade pip

# install glances monitoring tool
pip install glances[action,browser,cloud,cpuinfo,chart,docker,export,folders,gpu,ip,raid,snmp,web,wifi]

# install java
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
apt-get -y install oracle-java8-installer
apt-get -y install oracle-java8-set-default

# setup java home directory
echo 'JAVA_HOME="/usr/lib/jvm/java-8-oracle"' | tee -a /etc/environment
source /etc/environment

# install maven & ant
apt-get -y install maven ant

# install nodejs & npm
apt-get -y install nodejs

# install jenkins
apt-get -y install jenkins

# start jenkins
systemctl enable jenkins
systemctl start jenkins

# setup firewall
ufw --force enable
ufw allow 8080
ufw allow 8443
ufw allow OpenSSH

# clean up
apt-get clean
rm -rf /tmp/* /var/tmp/*