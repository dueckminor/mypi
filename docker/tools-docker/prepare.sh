#!/usr/bin/env bash

set -e

DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
DIR_THIS="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"

source "${DIR_ROOT}/scripts/lib/docker.sh"

cd "${DIR_THIS}"
mkdir -p ".docker/${CPU}"
cd .docker

if [[ ! -f "${CPU}/docker" ]]; then
    pushd ${CPU}
        wget -O "docker.tgz" "https://download.docker.com/linux/static/stable/${CPU}/docker-18.06.1-ce.tgz"
        tar xf "docker.tgz" --strip-components=1 docker/docker
        rm docker.tgz
    popd
fi
