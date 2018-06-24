#!/bin/bash

# intended for Ubuntu 64-bit

# ensure running as root
if [ "$(id -u)" != "0" ]; then
  exec sudo "$0" "$@"
fi

# set installation variables
export USERNAME="your_username"
export PASSWORD="your_password"
export FIRSTNAME="your_first_name"
export LASTNAME="your_last_name"
export EMAIL="your_email"

# setup language
echo "export LANG=en_US.UTF-8" | tee -a /etc/environment
echo "export LANGUAGE=en_US.UTF-8" | tee -a /etc/environment
echo "export LC_ALL=en_US.UTF-8" | tee -a /etc/environment
source /etc/environment

# update apt cache
apt-get update
apt-get -y install curl policycoreutils

# setup chef group
if [ ! $(grep -q chef-sudoers /etc/group) ]; then
    echo "Create Chef Sudoers Group..."
    groupadd chef-sudoers
    echo "%chef-sudoers ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers.d/chef_sudoers
fi

# setup chef user
if [ ! $(id -u ${USERNAME} > /dev/null 2>&1) ]; then
    echo "Create Chef Sudoers Group User..."
    useradd ${USERNAME} -G chef-sudoers -s /bin/bash && echo "${USERNAME}:${PASSWORD}" | chpasswd
    mkdir -p /home/${USERNAME}/.ssh
    cp -r /etc/skel/. /home/${USERNAME}/
    touch /home/${USERNAME}/.ssh/authorized_keys
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyHUAYWBNL59o3Gpw7DII3IoUbt8DhesAEyjgEjQ5JK3+5oWiat+zzJZCdmlYI6FiTugA491iGSpYvz1pbOew6AISMZEly80YLJz+2/DZTVcDhefXVWo6DRw168DxZbxKHK34I8Uua/vFWaW1nSNuqJ4Ps2mN2qNHLYWUurTrsu5tO8shYf5/KTm+oDBCsttYrQN4Xj8RoZe7h2HtrM0OVBIqB965iMRoJQvMv5iIEJ58oixGLzcpjStjTswjNxevj6Lw1hIepJ46MM0zm5eBaO659RZABY6gz6h9LAAFWf0g0F7+jDb7Lh5ScyJ1g1YeLh04roLvOa9nfv85hN/8r satriajidam@satriajidam-dev.local
" >> /home/${USERNAME}/.ssh/authorized_keys
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}
fi
