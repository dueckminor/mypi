FROM @ALPINE@

RUN apk add --no-cache nsd
RUN mkdir -p /var/run/nsd

ENTRYPOINT ["nsd"]
CMD ["-d"]
