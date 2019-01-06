#!/usr/bin/env bash

set -e

DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
DIR_THIS="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"

source "${DIR_ROOT}/scripts/lib/git.sh"
source "${DIR_ROOT}/scripts/lib/docker.sh"

Git::Sync https://github.com/certbot/certbot "${DIR_THIS}/src"

mkdir -p "${DIR_THIS}/src/.docker/${CPU}"
cp "${DIR_THIS}/../sandbox/sandbox.sh" "${DIR_THIS}/src/.docker/"

pushd "${DIR_THIS}/src/.docker/${CPU}"
    if [[ ! -f "./docker" ]]; then
        wget -O "docker.tgz" "https://download.docker.com/linux/static/stable/${CPU}/docker-18.06.1-ce.tgz"
        tar xf "docker.tgz" --strip-components=1 docker/docker
        rm docker.tgz
    fi
popd
