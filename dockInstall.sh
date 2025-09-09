#!/bin/bash

# This script install docker on RHEL 8 or 9


# your linux distribution may provide unofficial packages which may conflict with official packages so remove them
sudo dnf remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine \
                  podman \
                  runc


# If you install docker engine on new host machine for the first time you need to set up
# docker repository after that you can install/update from that repository

# Adding docker repository
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager -y --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

# Install latest docker engine
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start docker engine
sudo systemctl enable --now docker


# see docker version
docker version
docker --version






# To uninstall docker run
# sudo dnf remove docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

# Images, containers, volumes, or custom configuration files on your host aren't automatically removed. To delete all images, containers, and volumes
# sudo rm -rf /var/lib/docker
# sudo rm -rf /var/lib/containerd