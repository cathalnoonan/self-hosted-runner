#!/usr/bin/env bash
set -e

# Install docker using the convenience script.
# See: https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script
# Note: Any apt-get packages are installed in the Dockerfile

# GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 

# Use stable repository for Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm ./get-docker.sh
