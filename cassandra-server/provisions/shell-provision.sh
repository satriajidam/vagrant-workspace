#!/bin/bash

# Intended for Ubuntu 16.04 (Xenial) 64-bit

# Fix annoying "stdin: is not a tty" problem on provisioning
sudo sed -i "/mesg n/d" /root/.profile

# Adjust timezone to Jakarta
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Disable ssh password authentication
#sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
#sudo service ssh restart

# Update Ubuntu package manager
sudo apt-get update

# Setup language
touch ~/.profile
echo "export LANG=C" | tee -a ~/.profile
echo "export LC_ALL=C" | tee -a ~/.profile
source ~/.profile

# Install Oracle Java Development Kit 8 update 121
cd /tmp
echo "JAVA_HOME=/usr/lib/jvm/jdk1.8.0_121" | sudo tee -a /etc/environment
source /etc/environment
sudo mkdir -p "${JAVA_HOME}"
sudo tar -xvzf jdk-8u121-linux-x64.tar.gz -C "${JAVA_HOME}" --strip-components=1
sudo update-alternatives --install "/usr/bin/java" "java" "${JAVA_HOME}/bin/java" 1
sudo update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1
sudo update-alternatives --set java "${JAVA_HOME}/bin/java"
sudo update-alternatives --set javac "${JAVA_HOME}/bin/javac"

# Enable 4GB swap
cd /
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
sudo pip install --upgrade pip
sudo pip install glances

# Install Apache Cassandra 2.2.8
echo "deb http://www.apache.org/dist/cassandra/debian 22x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
sudo apt-get update
sudo apt-get install -y --allow-unauthenticated cassandra
sudo apt-get install -y --allow-unauthenticated cassandra-tools
sudo service cassandra stop
sudo rm -rf /var/lib/cassandra/data/system/*

# Clean up
sudo apt-get clean
sudo rm -rf /tmp/* /var/tmp/*
