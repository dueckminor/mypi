#!/usr/bin/env bash

set -e

DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
DIR_THIS="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"

source "${DIR_ROOT}/scripts/lib/git.sh"

Git::Sync https://github.com/docker-library/python "${DIR_THIS}/src"

cp "${DIR_THIS}/src/2.7/alpine3.8/Dockerfile" "${DIR_THIS}/Dockerfile"