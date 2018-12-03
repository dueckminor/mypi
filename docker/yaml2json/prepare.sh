#!/usr/bin/env bash

set -e

DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
DIR_THIS="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"

source "${DIR_ROOT}/scripts/lib/docker.sh"

cd "${DIR_THIS}"
mkdir -p ".docker/${CPU}"
cd .docker

if [[ ! -d yaml2json ]]; then
    git clone https://github.com/bronze1man/yaml2json.git
fi

if [[ ! -f ${CPU}/yaml2json ]]; then
    docker run \
        -v "$(pwd)/yaml2json:/go/src/github.com/bronze1man/yaml2json" \
        "${DOCKER_OWNER}/${CPU}-golang" \
        go build -o /go/src/github.com/bronze1man/yaml2json/yaml2json_${CPU} github.com/bronze1man/yaml2json 

    mv yaml2json/yaml2json_${CPU} ${CPU}/yaml2json
fi
