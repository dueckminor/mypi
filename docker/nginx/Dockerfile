FROM @ALPINE@

RUN apk add --no-cache nginx nginx-mod-stream
RUN mkdir /run/nginx

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
        && ln -sf /dev/stderr /var/log/nginx/error.log

ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
