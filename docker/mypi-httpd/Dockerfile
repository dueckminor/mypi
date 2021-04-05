FROM @OWNER@/@CPU@-builder AS builder

ENV MYPI_GIT_REPO=https://github.com/dueckminor/mypi-tools.git
ARG MYPI_GIT_COMMIT_ID=HEAD
ENV MYPI_GIT_COMMIT_ID=${MYPI_GIT_COMMIT_ID}

WORKDIR /go/src/github.com/dueckminor
RUN git clone https://github.com/dueckminor/mypi-tools.git
RUN go get github.com/dueckminor/mypi-tools/cmd/mypi-httpd

FROM @ALPINE@

COPY --from=builder /go/bin/mypi-httpd /usr/local/bin/mypi-httpd

WORKDIR /usr/local

ENTRYPOINT ["/usr/local/bin/mypi-httpd"]