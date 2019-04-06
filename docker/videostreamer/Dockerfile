FROM @OWNER@/@CPU@-golang

RUN apk add --no-cache ffmpeg-dev
RUN go get github.com/horgh/videostreamer

ENTRYPOINT ["/go/bin/videostreamer"]
