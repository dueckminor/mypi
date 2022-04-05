#!/usr/bin/env bash

set -e

DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
DIR_THIS="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"

source "${DIR_ROOT}/scripts/lib/docker.sh"

GetGID() {
    local GROUP_NAME="${1}"
    cat /etc/group | grep "^${GROUP_NAME}\:" | cut -d ':' -f 3
}
GetUID() {
    local USER_NAME="${1}"
    cat /etc/passwd | grep "^${USER_NAME}\:" | cut -d ':' -f 3
}

mkdir -p "${DIR_THIS}/src"
(
    cat "${DIR_THIS}/Dockerfile" |
    sed "s/%{UID_PI}/$(GetUID pi)/" |
    sed "s/%{GID_PI}/$(GetGID pi)/" |
    sed "s/%{GID_SUDO}/$(GetGID sudo)/" |
    sed "s/%{GID_DOCKER}/$(GetGID docker)/"
) > "${DIR_THIS}/src/Dockerfile"
