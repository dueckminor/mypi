#!/usr/bin/env bash

DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"

source "${DIR_ROOT}/scripts/lib/config.sh"
source "${DIR_ROOT}/scripts/lib/docker.sh"

INSTALL_ROOT="$(Config::GetRoot)"

Service::Start() {
    local SERVICE_NAME="${1}"
    local ARGS
    local CFG
    local SERVICE_IMAGE

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
        if [[ "${MOUNT}" =~ .*:.* ]]; then
            ARGS+=("-v" "${INSTALL_ROOT}/${MOUNT}")
        else
            mkdir -p "${INSTALL_ROOT}/${MOUNT}"
            ARGS+=("-v" "${INSTALL_ROOT}/${MOUNT}:/${MOUNT}")
        fi
    done

    Docker::Start "${SERVICE_NAME}" "${ARGS[@]}" "$(Docker::ImageName "${SERVICE_IMAGE}")"
}
