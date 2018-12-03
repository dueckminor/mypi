#!/usr/bin/env bash

DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
SYS="$(uname -s | awk '{print tolower($0)}')"
CPU="$(uname -m | awk '{print tolower($0)}')"

case "${CPU}" in
x86_64) CPU=amd64;;
esac

DOCKER_OWNER=dueckminor

Docker::ImageName()
{
    echo "${DOCKER_OWNER}/${CPU}-${1}"
}

Docker::ImageIsAvailable()
{
    docker image inspect "$(Docker::ImageName ${1})" &> /dev/null
}

Docker::ImageCreate()
{
    local SHORT_NAME="${1}"
    local DIR_DOCKER="${DIR_ROOT}/docker/${SHORT_NAME}"

    if [[ ! -f "${DIR_DOCKER}/Dockerfile" ]]; then
        false
    fi

    mkdir -p "${DIR_DOCKER}/.docker/${CPU}"

    local DOCKERFILE="${DIR_DOCKER}/.docker/${CPU}/Dockerfile"
    local TEMPLATE
 
    TEMPLATE="$(cat "${DIR_DOCKER}/Dockerfile")"
    TEMPLATE="$(sed "s,@CPU@,${CPU}," <<< "${TEMPLATE}")"
    TEMPLATE="$(sed "s,@OWNER@,${DOCKER_OWNER}," <<< "${TEMPLATE}")"

    echo "${TEMPLATE}" > "${DOCKERFILE}"

    pushd "${DIR_DOCKER}" > /dev/null
        if [[ -f "./prepare.sh" ]]; then
            "./prepare.sh"
        fi
        docker build . -f ".docker/${CPU}/Dockerfile" -t "$(Docker::ImageName ${SHORT_NAME})"
    popd > /dev/null

    true
}

Docker::ImageCreateMissing()
{
    if ! Docker::ImageIsAvailable "${1}"; then
        Docker::ImageCreate "${1}"
    fi
}
