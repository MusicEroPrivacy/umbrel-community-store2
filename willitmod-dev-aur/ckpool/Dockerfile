# ---- Build Stage ----
FROM alpine:3.19 AS builder

RUN apk add --no-cache \
    git \
    build-base \
    autoconf \
    automake \
    libtool \
    jansson-dev \
    zeromq-dev \
    linux-headers \
    curl

WORKDIR /build
RUN git clone --depth=1 https://bitbucket.org/ckolivas/ckpool.git ckpool-src
WORKDIR /build/ckpool-src
RUN ./autogen.sh && ./configure && make -j$(nproc)

# ---- Runtime Stage ----
FROM alpine:3.19

RUN apk add --no-cache \
    jansson \
    zeromq \
    curl \
    bash

COPY --from=builder /build/ckpool-src/src/ckpool /usr/local/bin/ckpool
COPY start.sh /start.sh
RUN chmod +x /start.sh

RUN mkdir -p /ckpool-logs
VOLUME ["/ckpool-logs"]
EXPOSE 3333

ENTRYPOINT ["/start.sh"]
