#!/bin/bash

# Intended for Ubuntu 16.04 (Xenial) 64-bit

# Fix annoying "stdin: is not a tty" problem on provisioning
sudo sed -i "/mesg n/d" /root/.profile

# Adjust timezone to Jakarta
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Disable ssh password authentication
sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
sudo service ssh restart

# Update Ubuntu package manager
sudo apt-get update

# Setup language
echo "export LANG=C" | sudo tee -a ~/.bashrc
echo "export LC_ALL=C" | sudo tee -a ~/.bashrc
source ~/.bashrc

# Enable 4GB swap
cd /
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile   none    swap    sw    0   0" | sudo tee -a /etc/fstab
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf 

# Install Percona Server 5.7
cd /tmp
wget https://repo.percona.com/apt/percona-release_0.1-4.$(lsb_release -sc)_all.deb
sudo dpkg -i percona-release_0.1-4.$(lsb_release -sc)_all.deb
sudo apt-get update
echo "percona-server-server-5.7 percona-server-server-5.7/root-pass password supersecret" | sudo debconf-set-selections
echo "percona-server-server-5.7 percona-server-server-5.7/re-root-pass password supersecret" | sudo debconf-set-selections
echo "percona-server-server-5.7 percona-server-server-5.7/remove-data-dir boolean true" | sudo debconf-set-selections
echo "percona-server-server-5.7 percona-server-server-5.7/data-dir note ok" | sudo debconf-set-selections
sudo apt-get install -y percona-server-server-5.7

# Clean up
sudo apt-get clean
sudo rm -rf /tmp/* /var/tmp/*
