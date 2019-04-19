FROM @ALPINE@ AS builder

RUN apk add --no-cache \
    autoconf \
    automake \
    ffmpeg-dev \
    gcc \
    libjpeg-turbo-dev \
    libmicrohttpd-dev \
    make \
    musl-dev

RUN wget https://github.com/Motion-Project/motion/archive/release-4.2.2.tar.gz \
&&  tar xzf release-4.2.2.tar.gz \
&&  cd motion-release-4.2.2 \
&&  autoreconf \
&&  ./configure \
&&  make \
&&  make install

FROM @ALPINE@
RUN apk add --no-cache \
    ffmpeg \
    libjpeg-turbo \
    libmicrohttpd \
    x265-libs

COPY --from=builder /usr/local /usr/local

