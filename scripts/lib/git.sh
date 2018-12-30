#!/usr/bin/env bash

Git::Sync() {
    local TARGET_DIR
    local TARGET_NAME
    TARGET_DIR="$(dirname "${2}")"
    TARGET_NAME="$(basename "${2}")"

    pushd "${TARGET_DIR}"  >/dev/null || return 1
    if [[ ! -d "${TARGET_NAME}/.git" ]]; then
        git clone "${1}" "${TARGET_NAME}"
    else
        pushd "${TARGET_NAME}" >/dev/null || return 1
            git reset --hard
            git pull
        popd >/dev/null || return 1
    fi
    popd >/dev/null || return 1
}