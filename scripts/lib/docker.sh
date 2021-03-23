#!/usr/bin/env bash

set -e

DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
# shellcheck disable=SC2034
SYS="$(uname -s | awk '{print tolower($0)}')"
CPU="$(uname -m | awk '{print tolower($0)}')"
ALPINE_VERSION=3.11.5

case "${CPU}" in
x86_64) 
    CPU=amd64
    GOARCH=amd64
    ;;
aarch64)
    CPU=aarch64
    GOARCH=arm64
    ;;
armv7l) 
    CPU=arm32v6
    GOARCH=arm
    ;;
esac

DOCKER_OWNER=dueckminor

Docker::ImageName()
{
    local IMAGE_NAME="${1}"
    if [[ "${IMAGE_NAME}" =~ .+/.+/.+ ]]; then
        echo "${IMAGE_NAME}"
    else
        echo "${DOCKER_OWNER}/${CPU}-${IMAGE_NAME}"
    fi
}

Docker::ImageIsAvailable()
{
    docker image inspect "$(Docker::ImageName "${1}")" &> /dev/null
}

Docker::ImageCreate()
{
    local SHORT_NAME="${1}"
    shift
    local DIR_DOCKER="${DIR_ROOT}/docker/${SHORT_NAME}"
    local DIR_DOCKER_BUILD="${DIR_DOCKER}"

    if [[ -f "${DIR_DOCKER}/prepare.sh" ]]; then
        "${DIR_DOCKER}/prepare.sh"
    fi

    if [[ -f "${DIR_DOCKER}/src/Dockerfile" ]]; then
        DIR_DOCKER_BUILD="${DIR_DOCKER}/src"
    fi

    if [[ ! -f "${DIR_DOCKER_BUILD}/Dockerfile" ]]; then
        false
    fi

    mkdir -p "${DIR_DOCKER_BUILD}/.docker/${CPU}"

    local DOCKERFILE="${DIR_DOCKER_BUILD}/.docker/${CPU}/Dockerfile"
    local TEMPLATE
 
    pushd "${DIR_DOCKER_BUILD}" > /dev/null
        TEMPLATE="$(cat "${DIR_DOCKER_BUILD}/Dockerfile")"
        TEMPLATE="$(sed "s,@ALPINE@,alpine:${ALPINE_VERSION}," <<< "${TEMPLATE}")"
        TEMPLATE="$(sed "s,@CPU@,${CPU}," <<< "${TEMPLATE}")"
        TEMPLATE="$(sed "s,@GOARCH@,${GOARCH}," <<< "${TEMPLATE}")"
        TEMPLATE="$(sed "s,@OWNER@,${DOCKER_OWNER}," <<< "${TEMPLATE}")"
        if [[ -f "${DIR_DOCKER}/filter.sh" ]]; then
            TEMPLATE="$("${DIR_DOCKER}/filter.sh" <<< "${TEMPLATE}")"
        fi

        echo "${TEMPLATE}" > "${DOCKERFILE}"

        MYPI_GIT_REPO=$(grep "ENV MYPI_GIT_REPO=" <<< "${TEMPLATE}" | sed 's/ENV MYPI_GIT_REPO=//')
        if [[ -n "${MYPI_GIT_REPO}" ]]; then
            MYPI_GIT_COMMIT_ID="$(git ls-remote https://github.com/dueckminor/mypi-tools.git HEAD)"
            MYPI_GIT_COMMIT_ID="$(sed 's/ .*//' <<< "${MYPI_GIT_COMMIT_ID}")"
            docker build . -f ".docker/${CPU}/Dockerfile" "${@}" --build-arg "MYPI_GIT_COMMIT_ID=${MYPI_GIT_COMMIT_ID}" -t "$(Docker::ImageName "${SHORT_NAME}")"
        else
            docker build . -f ".docker/${CPU}/Dockerfile" "${@}" -t "$(Docker::ImageName "${SHORT_NAME}")"
        fi
    popd > /dev/null

    true
}

Docker::ImageCreateMissing()
{
    if ! Docker::ImageIsAvailable "${1}"; then
        Docker::ImageCreate "${1}"
    fi
}

Docker::ImageCreateFromGO()
{
    false
}

Docker::Status() {
    docker inspect -f "{{.State.Running}}" "${1}" 2> /dev/null | grep -v "^$" || echo na
}

Docker::Start() {
    local NAME="${1}"
    shift
    local RUNNING
    RUNNING=$(Docker::Status "${NAME}")
    if [[ "${RUNNING}" == "true" ]]; then
        echo "${NAME} is running"
    elif [[ "${RUNNING}" == "false" ]]; then
        echo "restarting ${NAME}"
        docker start "${NAME}"
    else
        echo docker run -d --name "${NAME}" "$@"
        docker run -d --name "${NAME}" "$@"
    fi
}

Docker::Run() {
    local NAME="${1}"
    shift
    docker run -t "$@"
}

Docker::Exec() {
    local NAME="${1}"
    shift
    docker exec -t "${NAME}" "$@"
}

Docker::RunInteractive() {
    local NAME="${1}"
    shift
    docker run -it "${NAME}" "$@"
}

Docker::Stop() {
    if [[ "true" == "$(Docker::Status "${1}")" ]]; then
        docker stop "${1}"
    fi
}

Docker::Rm() {
    if docker inspect "${1}" &>/dev/null; then
        docker rm -f "${1}"
    fi
}

Docker::Sh() {
    local NAME="${1}"
    shift

    Docker::ImageCreateMissing "${NAME}"
    Docker::RunInteractive "$(Docker::ImageName "${NAME}")" "$@"
}