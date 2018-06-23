#!/bin/bash

# Intended for Ubuntu 14.04 (Trusty) 64-bit

# Fix annoying "stdin: is not a tty" problem on provisioning
sudo sed -i "/mesg n/d" /root/.profile

# Adjust timezone to Jakarta
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Disable ssh password authentication
sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
sudo service ssh restart

# Update Ubuntu package manager
sudo apt-get update

# Install prerequisites
sudo apt-get install -y ca-certificates
sudo locale-gen UTF-8
echo "LANG=C.UTF-8" | sudo tee -a /etc/environment
echo "LC_ALL=C.UTF-8" | sudo tee -a /etc/environment
source /etc/environment

# Install Oracle Java Development Kit 8
sudo apt-get install -y python-software-properties debconf-utils
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer
echo "JAVA_HOME=/usr/lib/jvm/java-8-oracle" | sudo tee -a /etc/environment
source /etc/environment

# Install Scala 2.11.8
cd /tmp
sudo dpkg -i scala-2.11.8.deb

# Enable 4GB swap
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile   none    swap    sw    0   0" | sudo tee -a /etc/fstab
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf 

# Install Glances monitoring tool
sudo apt-get install -y python
sudo apt-get update
sudo apt-get install -y build-essential python-dev python-pip
sudo pip install glances

# Install Kafka 2.11-0.10.1.1
cd /tmp
mkdir -p /home/vagrant/kafka
tar -xvzf kafka_2.11-0.10.1.1.tgz -C /home/vagrant/kafka --strip-components=1
sudo chown -R vagrant:vagrant /home/vagrant/kafka

# Clean up
sudo apt-get clean
sudo rm -rf /tmp/* /var/tmp/*
