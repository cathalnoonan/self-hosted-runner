FROM ubuntu:22.04

# An actions runner is not allowed to run as root by default.. fix that.
# See: https://github.com/actions/runner/blob/main/images/Dockerfile
ENV RUNNER_ALLOW_RUNASROOT=1
ENV ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1

# Install and update dependencies.
# Add additional packages below as necessary.
RUN apt-get update -y && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        dos2unix \
        sudo

# Install docker.
COPY install_docker.sh /
RUN chmod +x /install_docker.sh && \
    dos2unix /install_docker.sh && \
    /install_docker.sh

# Install github action runner (and it's dependencies).
WORKDIR /actions-runner
COPY install_runner.sh /
RUN chmod +x /install_runner.sh && \
    dos2unix /install_runner.sh && \
    /install_runner.sh && \
    /actions-runner/bin/installdependencies.sh

# Defer running 'start.sh' until the container is started.
COPY start.sh /
RUN chmod +x /start.sh && \
    dos2unix /start.sh
ENTRYPOINT ["/bin/bash", "/start.sh"]
