FROM @OWNER@/@CPU@-golang AS builder

RUN go get github.com/dueckminor/mypi-auth

FROM @OWNER@/@CPU@-ffmpeg

COPY --from=builder /go/bin/mypi-auth /usr/local/bin/mypi-auth
COPY --from=builder /go/src/github.com/dueckminor/mypi-auth/web /usr/local/web/

WORKDIR /usr/local

ENTRYPOINT ["/usr/local/bin/mypi-auth"]