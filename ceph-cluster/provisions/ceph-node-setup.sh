#!/bin/bash

# Intended for Ubuntu 16.04 (Xenial) 64-bit

# ensure running as root
if [ "$(id -u)" != "0" ]; then
  exec sudo "$0" "$@" 
fi

# Install NTP
apt-get install -y ntp

# Install SSH server
apt-get install -y openssh-server

# Setup password-less ceph-deploy user with sudo privileges (username:shaihulud, password:arrakis)
useradd -d /home/shaihulud -m shaihulud
echo "shaihulud:arrakis" | chpasswd
echo "shaihulud ALL=(root) NOPASSWD:ALL" | tee /etc/sudoers.d/shaihulud
chmod 0440 /etc/sudoers.d/shaihulud