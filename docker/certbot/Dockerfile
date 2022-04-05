FROM @ALPINE@

# The docker-cli is needed to run the hooks.
# The hooks use docker to trigger a DNS config reload
RUN apk add --no-cache certbot docker-cli

ENTRYPOINT ["certbot"]