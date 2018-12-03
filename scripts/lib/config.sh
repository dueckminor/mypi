#!/usr/bin/env bash

DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"

if [[ "$(command -v jq)" != "${DIR_ROOT}/scripts/bin/jq" ]]; then
    PATH="${DIR_ROOT}/scripts/bin:${PATH}:/usr/local/bin"
    export PATH
fi

if [[ -z "${_Config_JSON_}" ]]; then
    _Config_JSON_="$(cat "${DIR_ROOT}/config/mypi.json" | yaml2json)"
fi

Config::Get()
{
    jq -r "${1} // empty" <<< "${_Config_JSON_}"
}
