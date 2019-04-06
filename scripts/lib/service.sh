#!/usr/bin/env bash

set -e

DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"

# shellcheck source=/dev/null
source "${DIR_ROOT}/scripts/lib/config.sh"
# shellcheck source=/dev/null
source "${DIR_ROOT}/scripts/lib/docker.sh"

INSTALL_ROOT="$(Config::GetRoot)"

Service::_Do_() {
    local WHAT="${1}"
    shift
    local SERVICE_NAME="${1}"
    shift
    local ARGS
    local CFG
    local SERVICE_IMAGE
    local i

    CFG="$(Config::Load "${DIR_ROOT}/services/${SERVICE_NAME}/service.yml")"

    SERVICE_IMAGE="$(Config::Get "${CFG}" ".service.image")"

    ARGS=()

    for ((i = 0 ;  ; i++)); do
        PORT="$(Config::Get "${CFG}" ".service.ports[${i}]")"
        if [[ -z "${PORT}" ]]; then
            break
        fi
        ARGS+=("-p" "${PORT}")
    done

    for ((i = 0 ;  ; i++)); do
        ENV="$(Config::Get "${CFG}" ".service.env[${i}]")"
        if [[ -z "${ENV}" ]]; then
            break
        fi
        ARGS+=("--env" "${ENV}")
    done

    for ((i = 0 ;  ; i++)); do
        MOUNT="$(Config::Get "${CFG}" ".service.mount[${i}]")"
        if [[ -z "${MOUNT}" ]]; then
            break
        fi
        if [[ "${MOUNT}" == *:* ]]; then
            if [[ "${MOUNT}" == /* ]]; then
                ARGS+=("-v" "${MOUNT}")
            else
                ARGS+=("-v" "${INSTALL_ROOT}/${MOUNT}")
            fi
        else
            if [[ ! -e "${INSTALL_ROOT}/${MOUNT}" ]]; then
                mkdir -p "${INSTALL_ROOT}/${MOUNT}"
            fi
            ARGS+=("-v" "${INSTALL_ROOT}/${MOUNT}:/${MOUNT}")
        fi
    done

    ARGS+=("--restart" "unless-stopped")

    for ((i = 0 ;  ; i++)); do
        ARG="$(Config::Get "${CFG}" ".service.dockerargs[${i}]")"
        if [[ -z "${ARG}" ]]; then
            break
        fi
        ARGS+=("${ARG}")
    done

    ${WHAT} "${SERVICE_NAME}" "${ARGS[@]}" "$(Docker::ImageName "${SERVICE_IMAGE}")" "$@"
}

Service::Start() {
    Service::_Do_ "Docker::Start" "$@"
}

Service::Run() {
    Service::_Do_ "Docker::Run" "$@"
}

Service::RunInteractive() {
    Service::_Do_ "Docker::RunInteractive" "$@"
}

Service::Stop() {
    Docker::Stop "${1}"
}