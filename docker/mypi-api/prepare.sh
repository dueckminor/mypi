#!/usr/bin/env bash

set -e

DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
DIR_THIS="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"

source "${DIR_ROOT}/scripts/lib/docker.sh"
source "${DIR_ROOT}/scripts/lib/git.sh"

mkdir -p "${DIR_THIS}/.docker/${CPU}"

cd "${DIR_THIS}"

Git::Sync https://github.com/dueckminor/mypi-api "${DIR_THIS}/.docker/mypi-api"

cat > "${DIR_THIS}/.docker/${CPU}/build" << EOF
#!/bin/sh
cd /go/src/github.com/dueckminor/mypi-api
dep ensure
go build -o "/go/src/github.com/dueckminor/${CPU}/mypi-api" .
EOF

chmod 755 "${DIR_THIS}/.docker/${CPU}/build"

docker run \
    -v "${DIR_THIS}/.docker:/go/src/github.com/dueckminor" \
    "${DOCKER_OWNER}/${CPU}-golang" \
    "/go/src/github.com/dueckminor/${CPU}/build"
