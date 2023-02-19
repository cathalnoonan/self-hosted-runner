#!/usr/bin/env bash

# These variables need to be provided to the Docker container as environment variables.
# This can be done in the docker-compose.yml file.
GITHUB_API_HOST=$GITHUB_API_HOST
GITHUB_HOST=$GITHUB_HOST
OWNER=$OWNER
REPOSITORY=$REPOSITORY
PAT_TOKEN=$PAT_TOKEN

# Move to the correct folder to run the scripts.
cd /actions-runner

# Generate a registration_token when needed to avoid using expired tokens.
# See: https://docs.github.com/en/rest/actions/self-hosted-runners?apiVersion=2022-11-28#create-a-registration-token-for-a-repository
registration_token=''
get_regiration_token() {
    registration_token_json=$(
        curl -s \
            -X POST \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: Bearer $PAT_TOKEN"\
            -H "X-GitHub-Api-Version: 2022-11-28" \
            https://$GITHUB_API_HOST/repos/$OWNER/$REPOSITORY/actions/runners/registration-token
    )
    registration_token=$( echo $registration_token_json | sed -n 's|.*"token": "\([^"]*\)".*|\1|p' )
}

get_regiration_token
./config.sh --url https://$GITHUB_HOST/$OWNER/$REPOSITORY --token $registration_token --disableupdate
registration_token=''

# Use a trap function to remove the runners when the container is stopped.
cleanup() {
    echo "Removing runner '$(hostname)' ..."
    get_regiration_token
    ./config.sh remove --unattended --token $registration_token
    registration_token=''
    echo "Removed runner '$(hostname)'"
}
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
