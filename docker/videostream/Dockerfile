FROM @OWNER@/@CPU@-golang AS builder

RUN go get github.com/dueckminor/mypi-videostream

FROM @OWNER@/@CPU@-ffmpeg

COPY --from=builder /go/bin/mypi-videostream /usr/local/bin/mypi-videostream
COPY --from=builder /go/src/github.com/dueckminor/mypi-videostream/web /usr/local/web/

WORKDIR /usr/local

ENTRYPOINT ["/usr/local/bin/mypi-videostream"]