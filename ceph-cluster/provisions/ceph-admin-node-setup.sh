#!/bin/bash

# Intended for Ubuntu 16.04 (Xenial) 64-bit

# ensure running as root
if [ "$(id -u)" != "0" ]; then
  exec sudo "$0" "$@" 
fi

# Add the release key
wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -

# Add the Ceph packages to your repository
echo deb https://download.ceph.com/debian-luminous/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list

# Update repository and install ceph-deploy and sshpass
apt-get update
apt-get install -y ceph-deploy
apt-get install -y sshpass