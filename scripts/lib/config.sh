#!/usr/bin/env bash

DIR_ROOT="$(set -e ; cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"

#
# Ensure that we have a working `jq` in PATH
#
if [[ "$(command -v jq)" != "${DIR_ROOT}/scripts/bin/jq" ]]; then
    PATH="${DIR_ROOT}/scripts/bin:${PATH}:/usr/local/bin"
    export PATH
fi

Config::Load() {
    yaml2json < "${1}"
}

Config::Get() {
    if [[ $# == 1 ]]; then
        jq -r "${1} // empty" <<< "${_Config_JSON_}"
    elif [[ $# == 2 ]]; then
        jq -r "${2} // empty" <<< "${1}"
    else
        exit 1
    fi
}

#
# Read Config (if not already done)
#
if [[ -z "${_Config_JSON_}" ]]; then
    _Config_JSON_="$(Config::Load "${DIR_ROOT}/config/mypi.yml")"
fi

_Config_ROOT_=""

Config::GetRoot() {
    if [[ -n "${_Config_ROOT_}" ]]; then
        echo "${_Config_ROOT_}"
    fi
    _Config_ROOT_="$(Config::Get ".config.root")"
    if [[ -z "${_Config_ROOT_}" ]]; then
        exit 1
    fi
    if [[ ! -d "${_Config_ROOT_}" ]]; then
        exit 1
    fi
    echo "${_Config_ROOT_}"
}

Config::GetEtc() {
    echo "$(Config::GetRoot)/etc/${1}"
}

Config::ReadEtc() {
    local FILENAME
    FILENAME="$(Config::GetEtc "${1}")"
    cat "${FILENAME}"
}

Config::WriteEtc() {
    local FILENAME
    local DIRNAME
    FILENAME="$(Config::GetEtc "${1}")"
    DIRNAME="$(dirname "${FILENAME}")"
    mkdir -p "${DIRNAME}"
    cat > "${FILENAME}"
}

Config::AppendEtc() {
    local FILENAME
    local DIRNAME
    FILENAME="$(Config::GetEtc "${1}")"
    DIRNAME="$(dirname "${FILENAME}")"
    mkdir -p "${DIRNAME}"
    cat >> "${FILENAME}"
}

Config::WriteEtcStripped() {
    local FILENAME
    local DIRNAME
    FILENAME="$(Config::GetEtc "${1}")"
    DIRNAME="$(dirname "${FILENAME}")"
    mkdir -p "${DIRNAME}"
    cat | grep -v "^ *#" | grep -v "^ *$" > "${FILENAME}"
}