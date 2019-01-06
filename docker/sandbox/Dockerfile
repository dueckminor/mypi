FROM @ALPINE@

RUN apk add --no-cache ca-certificates iptables

COPY sandbox.sh /

RUN chmod 755 /sandbox.sh

ENTRYPOINT [ "/sandbox.sh" ]