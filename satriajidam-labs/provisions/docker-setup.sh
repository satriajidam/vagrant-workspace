# Setup 'vagrant' as docker user
sudo usermod -aG docker vagrant

# Setup docker service daemon configuration file
sudo cd /etc/docker
sudo touch daemon.json
sudo cat <<EOT > daemon.json
{
  "live-restore": true,
  "insecure-registries" : ["registry.micro.uii.id"]
}
EOT

# Create systemd init script for docker service
sudo systemctl daemon-reload && systemctl enable docker.service && systemctl restart docker.service
