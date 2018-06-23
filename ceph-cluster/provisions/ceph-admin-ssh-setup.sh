#!/bin/bash

# Intended for Ubuntu 16.04 (Xenial) 64-bit

# Generate SSH key
echo -e 'y\n' | ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa

# Copy SSH key to each Ceph Node
sshpass -p 'arrakis' ssh-copy-id -o StrictHostKeyChecking=no shaihulud@192.168.10.11
sshpass -p 'arrakis' ssh-copy-id -o StrictHostKeyChecking=no shaihulud@192.168.10.12
sshpass -p 'arrakis' ssh-copy-id -o StrictHostKeyChecking=no shaihulud@192.168.10.13
sshpass -p 'arrakis' ssh-copy-id -o StrictHostKeyChecking=no shaihulud@192.168.10.21
sshpass -p 'arrakis' ssh-copy-id -o StrictHostKeyChecking=no shaihulud@192.168.10.22

# Modify ~/.ssh/config so that ceph-deploy can log in to Ceph nodes as the created user
# without requiring to specify --username each time ceph-deploy is executed.
cat <<EOT > ~/.ssh/config
Host node1
    Hostname node1
    User shaihulud
    StrictHostKeyChecking no
Host node2
    Hostname node2
    User shaihulud
    StrictHostKeyChecking no
Host node3
    Hostname node3
    User shaihulud
    StrictHostKeyChecking no
Host client1
    Hostname client1
    User shaihulud
    StrictHostKeyChecking no
Host client2
    Hostname client2
    User shaihulud
    StrictHostKeyChecking no
EOT