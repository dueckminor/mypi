#!/usr/bin/env bash

DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"

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
