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
