#!/usr/bin/env bash

# Intended for Ubuntu 14.04 (Trusty)

# Disable ssh password authentication
sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
sudo service ssh restart

# Fix annoying "stdin: is not a tty" problem on provisioning
sudo sed -i "/mesg n/d" /root/.profile

# Install nginx
sudo apt-get -y update
sudo apt-get -y install nginx

# Remove default nginx configuration and use shared configuration instead
sudo rm -rf /etc/nginx/sites-enabled
sudo ln -s /vagrant/sites-enabled /etc/nginx/sites-enabled

# Remove default nginx html folder and use shared folder instead
sudo rm -rf /usr/share/nginx/html
sudo ln -s /vagrant/html /usr/share/nginx/html

# Start nginx
sudo service nginx start

# Install Docker, reference: https://docs.docker.com/engine/installation/linux/ubuntulinux/
# echo "----- Provision: Installing Docker..."
# sudo apt-get -y install apt-transport-https ca-certificates
# sudo apt-key adv \
#   --keyserver keyserver.ubuntu.com \
#   --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list
# sudo apt-get -y update
# apt-cache policy docker-engine
# sudo apt-get -y update
# sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
# sudo apt-get -y update
# sudo apt-get -y install docker-engine
