#!/usr/bin/env bash

set -e

DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
source "${DIR_ROOT}/scripts/lib/docker.sh"

sed "s,python:2-alpine3.7,python:2-alpine3.8," | grep -v "^EXPOSE"

cat <<EOF
COPY .docker/${CPU}/docker /usr/local/bin
RUN chmod 755 /usr/local/bin/docker
EOF

