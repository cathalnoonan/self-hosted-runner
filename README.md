# Self-Hosted Runner (GitHub Actions)
This repository contains the necessary configuration to run self-hosted runners at a repository level within Docker Compose.

## Required Software
- Docker (with docker compose installed).
  - Check if docker is installed by running the following command:
    ```sh
    docker --version
    # Should see: "Docker version ..."
    ```
  - Check if docker compose is installed by running the following command:
    ```sh
    docker compose version
    # Should see: "Docker compose version ..."
    ```

## Setup
Clone this repository.

Before starting up the runners, you will need to create a Personal Access Token (PAT Token) in the GitHub user interface. \
[Refer to this link for instructions to create a PAT Token.](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

The Personal Access Token should be given the following permission(s) in the repository where you wish to use the runner:
- `Administration (Read and write)`
  - This permission is required to register self-hosted runners. \
    [Refer to this link for more information about permissions.](https://docs.github.com/en/rest/overview/permissions-required-for-fine-grained-personal-access-tokens?apiVersion=2022-11-28#administration)

Open the `docker-compose.yml` file in a text editor, and enter the required information underneath the `environment` section:
```yml
version: '3.9'
services:
  runner:
    # ...
    environment:
      - GITHUB_HOST=github.com
      - GITHUB_API_HOST=api.github.com
      - OWNER=<your_username>
      - REPOSITORY=<your_repository_name>
      - PAT_TOKEN=<your_personal_access_token>
```

| Key name | Description | Example value |
|:---|:---|:---|
| GITHUB_HOST | Enter the GitHub URL. | `github.com` |
| GITHUB_API_HOST | Enter the GitHub API URL. | `api.github.com` |
| OWNER | Enter your GitHub username. | `cathalnoonan` |
| REPOSITORY | Enter the name of the repository where the runner(s) should be registered. | `self-hosted-runner` |
| PAT_TOKEN | Enter the Personal Access Token created in the steps above. | `github_pat_ABCDEF...` |

## Starting and stopping runners
The following commands should be run at the root directory of the cloned repository.

- Build the runner image:
  ```sh
  docker compose build
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

## Important note about using docker in the self-hosted runner
Running docker commands inside the self-hosted runner will not operate as a 'docker in docker' scenario.
Instead, the containers that are created will use the host's docker engine to spawn the containers.

This is done by mounting `/var/run/docker.sock` from the host machine to the runner container(s) inside `./docker-compose.yml`
```yml
version: '3.9'
services:

  runner:
    # ...
    volumes:
      # Mount docker.sock so that containers can spawn other containers on the host machine.
      # Note: This is NOT a true docker-in-docker.
      # Note: This may present security risks.
      - /var/run/docker.sock:/var/run/docker.sock:ro

```

**This may present security issues, so do not use self-hosted runners in a repo where you do not have control of the code that could be executed.**
