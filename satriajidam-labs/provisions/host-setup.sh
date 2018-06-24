#!/bin/bash

# Intended for Ubuntu 16.04 (Xenial) 64-bit

# Fix annoying "stdin: is not a tty" problem on provisioning
sudo sed -i "/mesg n/d" /root/.profile

# Adjust timezone to Jakarta
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Disable ssh password authentication
sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
sudo service ssh restart

# Setup language
echo "export LANG=en_US.UTF-8" | tee -a /etc/environment
echo "export LANGUAGE=en_US.UTF-8" | tee -a /etc/environment
echo "export LC_ALL=en_US.UTF-8" | tee -a /etc/environment
source /etc/environment

# Enable 4GB swap
cd /
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile   none    swap    sw    0   0" | sudo tee -a /etc/fstab
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf

# Update Ubuntu package manager
sudo apt-get update

# Install Glances monitoring tool
sudo apt-get install -y python
sudo apt-get update
sudo apt-get install -y build-essential python-dev python-pip
sudo pip install glances

# Clean up
sudo apt-get clean
sudo rm -rf /tmp/* /var/tmp/*