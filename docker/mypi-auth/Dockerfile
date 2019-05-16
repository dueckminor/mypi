FROM @OWNER@/@CPU@-builder AS builder

RUN go get github.com/dueckminor/mypi-auth

WORKDIR /go/src/github.com/dueckminor/mypi-auth
RUN npm install
RUN npm run build

FROM @ALPINE@

COPY --from=builder /go/bin/mypi-auth /usr/local/bin/mypi-auth
COPY --from=builder /go/src/github.com/dueckminor/mypi-auth/dist /usr/local/dist/

WORKDIR /usr/local

ENTRYPOINT ["/usr/local/bin/mypi-auth"]