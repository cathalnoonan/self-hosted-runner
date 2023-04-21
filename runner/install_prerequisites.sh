#!/bin/sh

sudo_command=""

if [ "$(command -v sudo)" != "" ]; then
    sudo_command="sudo"
fi

if [ "$(command -v apt-get)" != "" ]; then
    $sudo_command apt-get -y update
    $sudo_command apt-get -y --no-install-recommends install \
        apt-transport-https \
        bash \
        build-essential \
        ca-certificates \
        curl \
        dos2unix \
        gnupg

    # Bit hacky.. install either `lsb-core` or `lsb-release`
    $sudo_command apt-get -y --no-install-recommends install \
        lsb-core || \
    $sudo_command apt-get -y --no-install-recommends install \
        lsb-release

elif [ "$(command -v dnf)" != "" ]; then
    $sudo_command dnf -y update
    $sudo_command dnf -y install \
        bash \
        ca-certificates \
        curl \
        dos2unix \
        gnupg \
        redhat-lsb-core \
        sudo
fi


# Install docker using the convenience script.
# See: https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script
# Note: Any apt-get packages are installed in the Dockerfile

# Use stable repository for Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm ./get-docker.sh