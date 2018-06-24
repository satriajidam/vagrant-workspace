#!/bin/bash

# intended for Ubuntu 64-bit

# ensure running as root
if [ "$(id -u)" != "0" ]; then
  exec sudo "$0" "$@"
fi

# set installation variables
export CHEF_SERVER_VERSION="12.17.33"
export USERNAME="your_username"
export PASSWORD="your_password"
export FIRSTNAME="your_first_name"
export LASTNAME="your_last_name"
export EMAIL="your_email"
export ORGANIZATION="your_organization"
export ORGANIZATION_INFO="your_organization_info"

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

# create certificates directory
if [ ! -d /var/chef/certs ]; then
    mkdir -p /var/chef/certs/user
    mkdir -p /var/chef/certs/org
fi

# create downloads directory
if [ ! -d /downloads ]; then
    mkdir /downloads
fi

# download the Chef server package
if [ ! -f /downloads/chef-server-core_${CHEF_SERVER_VERSION}-1_amd64.deb ]; then
    echo "Downloading the Chef server package..."
    wget -P /downloads https://packages.chef.io/files/stable/chef-server/${CHEF_SERVER_VERSION}/ubuntu/16.04/chef-server-core_${CHEF_SERVER_VERSION}-1_amd64.deb
fi

# install Chef server
if [ ! $(which chef-server-ctl) ]; then
    echo "Installing Chef server..."
    dpkg -i /downloads/chef-server-core_${CHEF_SERVER_VERSION}-1_amd64.deb
    chef-server-ctl reconfigure

    echo "Waiting for services..."
    until (curl -D - http://localhost:8000/_status) | grep "200 OK"; do sleep 15s; done
    while (curl http://localhost:8000/_status) | grep "fail"; do sleep 15s; done

    echo "Creating initial user and organization..."
    chef-server-ctl user-create ${USERNAME} ${FIRSTNAME} ${LASTNAME} ${EMAIL} ${PASSWORD} --filename /var/chef/certs/user/${USERNAME}.pem
    chef-server-ctl org-create ${ORGANIZATION} ${ORGANIZATION_INFO} --association_user ${USERNAME} --filename /var/chef/certs/org/${ORGANIZATION}-validator.pem
fi

# clean up
apt-get clean
rm -rf /tmp/* /var/tmp/* /downloads

# unset installation variables
# unset CHEF_SERVER_VERSION
# unset USERNAME
# unset PASSWORD
# unset FIRSTNAME
# unset LASTNAME
# unset EMAIL
# unset ORGANIZATION
# unset ORGANIZATION_INFO

echo "Your Chef server is ready!"
