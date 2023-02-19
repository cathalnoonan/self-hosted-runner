#!/usr/bin/env bash
set -e

os=""
arch=""
runner_version=""

if [[ "$os" == "" ]]; then
    case "$OSTYPE" in
        darwin*)     os="osx" ;;
        linux*)      os="linux" ;;
        msys*)       os="win" ;;
        cygwin*)     os="win" ;;
        *)           echo "Unknown OSTYPE: $OSTYPE" && exit 1 ;;
    esac
fi

if [[ "$arch" == "" ]]; then
    case "$(uname -m)" in
        x86_64*)     arch="x64" ;;
        arm64*)      arch="arm64" ;;
        aarch64*)    arch="arm64" ;;
        *)           echo "Unknown arch: $(uname -m)" && exit 1 ;;
    esac
fi

if [[ "$runner_version" == "" ]]; then
    # Get the latest release JSON, strip out the numeric part of "tag_name".
    runner_version=$( curl -s "https://api.github.com/repos/actions/runner/releases/latest" | sed -n 's|.*"tag_name": "v\([^"]*\)".*|\1|p' )
fi

curl -O -L https://github.com/actions/runner/releases/download/v${runner_version}/actions-runner-${os}-${arch}-${runner_version}.tar.gz
tar xzf ./actions-runner-${os}-${arch}-${runner_version}.tar.gz
rm ./actions-runner-${os}-${arch}-${runner_version}.tar.gz

./bin/installdependencies.sh
