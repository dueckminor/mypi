FROM @OWNER@/@CPU@-builder AS builder

ENV MYPI_GIT_REPO=https://github.com/dueckminor/mypi-tools.git
ARG MYPI_GIT_COMMIT_ID=HEAD
ENV MYPI_GIT_COMMIT_ID=${MYPI_GIT_COMMIT_ID}

WORKDIR /go/src/github.com/dueckminor
RUN git clone https://github.com/dueckminor/mypi-tools.git
WORKDIR /go/src/github.com/dueckminor/mypi-tools
RUN go get ./go/...

RUN go build -o /usr/local/bin/mypi-videostream cmd/mypi-videostream/*.go

WORKDIR /go/src/github.com/dueckminor/mypi-tools/web/mypi-videostream
RUN npm install
RUN npm run build

FROM @OWNER@/@CPU@-ffmpeg

COPY --from=builder /go/bin/mypi-videostream /usr/local/bin/mypi-videostream
COPY --from=builder /go/src/github.com/dueckminor/mypi-tools/web/mypi-videostream/dist /usr/local/dist/

WORKDIR /usr/local

ENTRYPOINT ["/usr/local/bin/mypi-videostream"]