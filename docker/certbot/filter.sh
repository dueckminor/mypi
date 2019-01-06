#!/usr/bin/env bash

set -e

DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
source "${DIR_ROOT}/scripts/lib/docker.sh"

sed "s,python:2-alpine3.7,python:2-alpine3.8," | grep -v "^EXPOSE"

cat <<EOF
RUN rm /usr/local/lib/python2.7/site-packages/certifi/cacert.pem && ln -s /etc/ssl/cert.pem /usr/local/lib/python2.7/site-packages/certifi/cacert.pem
ENV ENTRYPOINT certbot
ENV REQUESTS_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt
COPY .docker/sandbox.sh /sandbox.sh
COPY .docker/sandbox.sh /sandbox.sh
RUN chmod 755 /sandbox.sh
COPY .docker/${CPU}/docker /usr/local/bin
RUN chmod 755 /usr/local/bin/docker
ENTRYPOINT [ "/sandbox.sh" ]
EOF

