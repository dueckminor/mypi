FROM @OWNER@/@CPU@-builder AS builder

ENV MYPI_GIT_REPO=https://github.com/dueckminor/mypi-tools.git
ARG MYPI_GIT_COMMIT_ID=HEAD
ENV MYPI_GIT_COMMIT_ID=${MYPI_GIT_COMMIT_ID}

WORKDIR /go/src/github.com/dueckminor
RUN git clone https://github.com/dueckminor/mypi-tools.git
WORKDIR /go/src/github.com/dueckminor/mypi-tools
RUN go get ./go/...

RUN go build -o /usr/local/bin/mypi-auth cmd/mypi-auth/*.go

WORKDIR /go/src/github.com/dueckminor/mypi-tools/web/mypi-auth
RUN npm install
RUN npm run build

FROM @ALPINE@

COPY --from=builder /usr/local/bin/mypi-auth /usr/local/bin/mypi-auth
COPY --from=builder /go/src/github.com/dueckminor/mypi-tools/web/mypi-auth/dist /usr/local/dist/

WORKDIR /usr/local

ENTRYPOINT ["/usr/local/bin/mypi-auth"]