FROM @OWNER@/@CPU@-builder AS builder

ENV MYPI_GIT_REPO=https://github.com/dueckminor/mypi-tools.git
ARG MYPI_GIT_COMMIT_ID=HEAD
ENV MYPI_GIT_COMMIT_ID=${MYPI_GIT_COMMIT_ID}

WORKDIR /go/src/github.com/dueckminor
RUN git clone https://github.com/dueckminor/mypi-tools.git
WORKDIR /go/src/github.com/dueckminor/mypi-tools
RUN go get ./go/...

RUN go build -o /usr/local/bin/mypi-router cmd/mypi-router/*.go

FROM @ALPINE@

RUN apk add --no-cache ca-certificates

COPY --from=builder /usr/local/bin/mypi-router /usr/local/bin/mypi-router

WORKDIR /usr/local

ENTRYPOINT ["/usr/local/bin/mypi-router"]