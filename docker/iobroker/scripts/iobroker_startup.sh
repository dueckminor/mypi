#!/bin/bash

set -e

if [[ ! -f /opt/iobroker/iobroker ]]; then
    cd /opt
    tar xf iobroker.tar
    cd iobroker
    ./iobroker host this
fi

cd /opt/iobroker
node node_modules/iobroker.js-controller/controller.js