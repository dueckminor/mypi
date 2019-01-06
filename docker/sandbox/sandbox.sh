#!/bin/sh

if ls /usr/local/share/ca-certificates/* >/dev/null 2>&1; then
    update-ca-certificates 2>&1 | grep -v "WARNING: ca-certificates.crt" >&2
fi

if [ "${1}" = "--" ]; then
    shift
    if [ "$#" = 0 ]; then
        ash -l
    else
        "$@"
    fi
else
    if [ -z "${ENTRYPOINT}" ]; then
        "$@"
    else
        "${ENTRYPOINT}" "$@"
    fi
fi
