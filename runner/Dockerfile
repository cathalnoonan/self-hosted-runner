FROM ubuntu:22.04
WORKDIR /actions-runner

# An actions runner is not allowed to run as root by default.. fix that.
# See: https://github.com/actions/runner/blob/main/images/Dockerfile
ENV RUNNER_ALLOW_RUNASROOT=1
ENV ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1

# Install and update dependencies.
# Add additional packages below as necessary.
RUN apt-get update -y && \
    apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        dos2unix \
        gnupg \
        lsb-release \
        software-properties-common

# Install docker.
COPY install_docker.sh .
RUN chmod +x ./install_docker.sh && \
    dos2unix ./install_docker.sh && \
    ./install_docker.sh && \
    rm ./install_docker.sh

# Install github action runner (and it's dependencies).
COPY install_runner.sh .
RUN chmod +x ./install_runner.sh && \
    dos2unix ./install_runner.sh && \
    ./install_runner.sh && \
    rm ./install_runner.sh && \
    ./bin/installdependencies.sh

# Defer running 'start_runner.sh' until the container is started.
COPY start_runner.sh .
RUN chmod +x ./start_runner.sh && \
    dos2unix ./start_runner.sh
ENTRYPOINT ["/bin/bash", "./start_runner.sh"]
