#!/bin/bash

# Intended for Ubuntu 16.04 (Xenial) 64-bit

# Create ceph cluster directory
mkdir ~/shaihulud-cluster
cd ~/shaihulud-cluster

# Create initial monitor node(s)
ceph-deploy new node1 node2 node3

# Install ceph packages on node(s)
ceph-deploy install --release luminous node1 node2 node3

# Deploy the initial monitor(s) and gather the keys
ceph-deploy mon create-initial

# Install ceph packages on client(s)
ceph-deploy install --release luminous client1 client2

# Copy configuration file to node(s)
ceph-deploy admin node1 node2 node3 client1 client2

# Deploy manager daemon on node(s)
ceph-deploy mgr create node1 node2 node3

# Deploy metadata server on node(s)
ceph-deploy mds create node1