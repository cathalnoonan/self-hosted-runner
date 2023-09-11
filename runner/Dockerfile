FROM ubuntu:22.04
WORKDIR /actions-runner

##
# An actions runner is not allowed to run as root by default.. fix that.
# See: https://github.com/actions/runner/blob/main/images/Dockerfile
##
ENV RUNNER_ALLOW_RUNASROOT=1
ENV ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1

##
# Dotnet prep
##
ENV DOTNET_ROOT=/.dotnet
ENV DOTNET_INSTALL_DIR=${DOTNET_ROOT}
ENV PATH=${PATH}:${DOTNET_ROOT}:${DOTNET_ROOT}/tools

##
# Install Docker (using convenience script)
##
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install \
        apt-transport-https \
        bash \
        build-essential \
        ca-certificates \
        curl \
        dos2unix \
        gnupg \
        sudo \
        wget
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    rm ./get-docker.sh

##
# Install github action runner (and it's dependencies).
##
COPY install_runner.sh .
RUN chmod +x ./install_runner.sh && \
    ./install_runner.sh && \
    rm ./install_runner.sh && \
    ./bin/installdependencies.sh

##
# Defer running 'start_runner.sh' until the container is started.
##
COPY start_runner.sh .
RUN chmod +x ./start_runner.sh
ENTRYPOINT ["/bin/bash", "./start_runner.sh"]
