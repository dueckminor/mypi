#!/usr/bin/env bash

set -e

DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
DIR_THIS="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"

cd "${DIR_THIS}"

if [[ ! -d ./src/.git ]]; then
    git clone https://github.com/certbot/certbot src
else
    pushd ./src >/dev/null
        git reset --hard
        git pull
    popd >/dev/null
fi

