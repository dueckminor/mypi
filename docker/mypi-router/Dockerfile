FROM @OWNER@/@CPU@-builder AS builder

RUN go get github.com/dueckminor/mypi-router

FROM @ALPINE@

RUN apk add --no-cache ca-certificates

COPY --from=builder /go/bin/mypi-router /usr/local/bin/mypi-router

WORKDIR /usr/local

ENTRYPOINT ["/usr/local/bin/mypi-router"]