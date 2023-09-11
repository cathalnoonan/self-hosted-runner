# Self-Hosted Runner (GitHub Actions)
This repository contains the necessary configuration to run self-hosted runners at a repository level within Docker Compose.

## Required Software
- Docker (with docker compose installed).
  - Check if docker is installed by running the following command:
    ```sh
    docker --version
    ```
    ```sh
    # Should see ab output like:
    Docker version 24.0.6, build ed223bc
    ```
  - Check if docker compose is installed by running the following command:
    ```sh
    docker compose version
    ```
    ```sh
    # Should see an output like:
    Docker Compose version v2.21.0
    ```

- Install and configure `sysbox`
   - Refer to [nesty/sysbox repo](https://github.com/nestybox/sysbox)
   - Update `daemon.json` as required
      ```jsonc
      {
        // (omitted)
        "runtimes": {
          "sysbox-runc": {
            "path": "/usr/bin/sysbox-runc"
          }
        },
        "userns-remap": "sysbox"
        // (omitted)
      }
      ```
    - Check if the service is running
       ```sh
       sudo systemctl status sysbox
       ```
       ```sh
       # Should see an output like:
       user@hostname:~ $ sudo systemctl status sysbox
       ● sysbox.service - Sysbox container runtime
            Loaded: loaded (/lib/systemd/system/sysbox.service; enabled; vendor preset: enabled)
            Active: active (running) since Mon 2023-09-11 19:09:17 IST; 1h 58min ago
              Docs: https://github.com/nestybox/sysbox
          Main PID: 911 (sh)
             Tasks: 2 (limit: 37637)
            Memory: 16.0M
            CGroup: /system.slice/sysbox.service
                    ├─ 911 /bin/sh -c /usr/bin/sysbox-runc --version && /usr/bin/sysbox-mgr --version && /usr/bin/sysbox-fs --version && /bin/sleep infinity
                    └─1027 /bin/sleep infinity
       ```

## Setup
1. Clone this repository.

1. Before starting up the runners, you will need to create a Personal Access Token (PAT Token) in the GitHub user interface. \
   [Refer to this link for instructions to create a PAT Token.](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

1. The Personal Access Token should be given the following permission(s) in the repository where you wish to use the runner:
   - `Administration (Read and write)`
     - This permission is required to register self-hosted runners. \
       [Refer to this link for more information about permissions.](https://docs.github.com/en/rest/overview/permissions-required-for-fine-grained-personal-access-tokens?apiVersion=2022-11-28#administration)

1. Open the `docker-compose.yml` file in a text editor, and enter the required information underneath the `environment` section:
   ```yml
   version: '3.9'
   services:
     runner:
       # ...
       environment:
         # Default values
         - GITHUB_HOST=github.com
         - GITHUB_API_HOST=api.github.com

         # Required values
         - OWNER=<your_username>
         - REPOSITORY=<your_repository_name>
         - PAT_TOKEN=<your_personal_access_token>

         # Optional values
         - GITHUB_ACTION_RUNNER_VERSION=<leave_blank_for_latest>
         - CUSTOM_LABELS=<leave_blank_to_not_add_additional_labels>
   ```

| Key name | Description | Example value |
|:---|:---|:---|
| GITHUB_HOST | Enter the GitHub URL. | `github.com` |
| GITHUB_API_HOST | Enter the GitHub API URL. | `api.github.com` |
| GITHUB_ACTION_RUNNER_VERSION | Version of the GitHub action runner to install. <br/>Leave blank to use the latest version. | (blank) or version, e.g. `2.302.1` |
| OWNER | Enter your GitHub username. | `cathalnoonan` |
| REPOSITORY | Enter the name of the repository where the runner(s) should be registered. | `self-hosted-runner` |
| PAT_TOKEN | Enter the Personal Access Token created in the steps above. | `github_pat_ABCDEF...` |
| CUSTOM_LABELS | Enter any **additional** labels that should be added to the runner. | `Ubuntu-22.04,docker` |

## Starting and stopping runners
The following commands should be run at the root directory of the cloned repository.

- Build the runner image:
  ```sh
  docker compose build
  ```
  - To avoid the build cache, instead run:
    ```sh
    docker compose build --no-cache
    ```

- Starting a single runner:
  ```sh
  docker compose up -d
  ```

- Starting multiple runners (replace `2` below as required):
  ```sh
  docker compose up -d --scale runner=2
  ```

- Stopping the runners:
  ```sh
  docker compose down
  ```
