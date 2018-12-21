#!/usr/bin/env bash

set -e

DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
DIR_THIS="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"

source "${DIR_ROOT}/scripts/lib/docker.sh"

mkdir -p "${DIR_THIS}/.docker/${CPU}"

docker run \
    -v "${DIR_ROOT}:/go/src/github.com/dueckminor/mypi" \
    "${DOCKER_OWNER}/${CPU}-golang" \
    go build -o "/go/src/github.com/dueckminor/mypi/docker/mypi-login/.docker/${CPU}/mypi-login" "github.com/dueckminor/mypi/cmd/login"
