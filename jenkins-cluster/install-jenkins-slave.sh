#!/bin/bash

# intended for Ubuntu 64-bit

# ensure running as root
if [ "$(id -u)" != "0" ]; then
  exec sudo "$0" "$@" 
fi

# setup jre
apt-get update
apt-get -y install default-jre openssh-server

# setup jenkins user
if [ ! $(id -u jenkins > /dev/null 2>&1) ]; then
  useradd jenkins -s /bin/bash && echo "jenkins:jenkins" | chpasswd
  usermod -aG sudo jenkins
fi

# setup firewall
ufw enable
ufw allow OpenSSH

# clean up
apt-get clean
rm -rf /tmp/* /var/tmp/*