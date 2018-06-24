#!/usr/bin/env bash

# Intended for Ubuntu 14.04 (Trusty) 64-bit

# Fix annoying "stdin: is not a tty" problem on provisioning
# sudo sed -i "/mesg n/d" /root/.profile

# Adjust timezone to Jakarta
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Disable ssh password authentication
sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
sudo service ssh restart

# Update Ubuntu package manager
sudo apt-get -y update

# Install HTTPie
echo "----- Provision: Installing HTTPie..."
sudo apt-get -y install httpie

# Install kubectl v1.5.1
echo "----- Provision: Installing kubectl..."
if [ ! -f /usr/local/bin/kubectl ]; then
  wget --progress=bar:force -O kubectl http://storage.googleapis.com/kubernetes-release/release/v1.5.1/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    sudo mv kubectl /usr/local/bin/
else
  echo "----- kubectl already installed in: $(which kubectl)"
fi

# Install Docker, reference: https://docs.docker.com/engine/installation/linux/ubuntulinux/
# Vagrant has a built-in docker provisioner, but it slows as f*ck!
# Use this as an alternative if your internet connection is slow.
# echo "----- Provision: Installing Docker..."
# if [ ! -f /usr/bin/docker ]; then
#   sudo apt-get -y install apt-transport-https ca-certificates
#   sudo apt-key adv \
#     --keyserver keyserver.ubuntu.com \
#     --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
#   echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list
#   sudo apt-get -y update
#   apt-cache policy docker-engine
#   sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
#   sudo apt-get -y install docker-engine
# else
#   echo "----- docker already installed in: $(which docker)"
# fi
