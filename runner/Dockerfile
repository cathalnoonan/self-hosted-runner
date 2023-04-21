ARG BASE_IMAGE=ubuntu:22.04

FROM ${BASE_IMAGE}
WORKDIR /actions-runner

# An actions runner is not allowed to run as root by default.. fix that.
# See: https://github.com/actions/runner/blob/main/images/Dockerfile
ENV RUNNER_ALLOW_RUNASROOT=1
ENV ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1

# Install prerequisites.
COPY install_prerequisites.sh .
RUN chmod +x ./install_prerequisites.sh && \
    ./install_prerequisites.sh && \
    rm ./install_prerequisites.sh

# Install github action runner (and it's dependencies).
COPY install_runner.sh .
RUN chmod +x ./install_runner.sh && \
    ./install_runner.sh && \
    rm ./install_runner.sh && \
    ./bin/installdependencies.sh

# Defer running 'start_runner.sh' until the container is started.
COPY start_runner.sh .
RUN chmod +x ./start_runner.sh
ENTRYPOINT ["/bin/bash", "./start_runner.sh"]
