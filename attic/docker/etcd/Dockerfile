FROM @OWNER@/@CPU@-golang AS builder

RUN apk add --no-cache bash
RUN mkdir -p /build
WORKDIR /build
RUN git clone https://github.com/coreos/etcd.git
WORKDIR /build/etcd
RUN ./build

FROM @ALPINE@

COPY --from=builder /build/etcd/bin/etcd /usr/local/bin/etcd
COPY --from=builder /build/etcd/bin/etcdctl /usr/local/bin/etcdctl

WORKDIR /usr/local

ENV ETCD_UNSUPPORTED_ARCH @GOARCH@

EXPOSE 2379 2380

ENTRYPOINT ["/usr/local/bin/etcd"]