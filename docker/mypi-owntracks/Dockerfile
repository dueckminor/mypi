FROM @OWNER@/@CPU@-builder AS builder

ENV MYPI_GIT_REPO=https://github.com/dueckminor/mypi-tools.git
ARG MYPI_GIT_COMMIT_ID=HEAD
ENV MYPI_GIT_COMMIT_ID=${MYPI_GIT_COMMIT_ID}

WORKDIR /go/src/github.com/dueckminor
RUN git clone https://github.com/dueckminor/mypi-tools.git
RUN go get github.com/dueckminor/mypi-tools/cmd/mypi-owntracks

FROM @ALPINE@

RUN apk add --no-cache ca-certificates

COPY --from=builder /go/bin/mypi-owntracks /usr/local/bin/mypi-owntracks

WORKDIR /usr/local

ENTRYPOINT ["/usr/local/bin/mypi-owntracks"]