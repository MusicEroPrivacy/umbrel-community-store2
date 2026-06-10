# ---- Build Stage ----
FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    libtool \
    autotools-dev \
    automake \
    pkg-config \
    libssl-dev \
    libevent-dev \
    libboost-all-dev \
    libdb5.3-dev \
    libdb5.3++-dev \
    libminiupnpc-dev \
    libzmq3-dev \
    python3 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
RUN git clone --depth=1 --branch master https://github.com/aurarad/Auroracoin.git auroracoin

WORKDIR /build/auroracoin
RUN ./autogen.sh
RUN ./configure \
    --disable-tests \
    --disable-bench \
    --disable-gui-tests \
    --without-gui \
    --with-incompatible-bdb \
    --enable-reduce-exports \
    CXXFLAGS="-O2"
RUN make -j$(nproc)
RUN make install

# ---- Runtime Stage ----
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libevent-2.1-7 \
    libboost-filesystem1.74.0 \
    libboost-thread1.74.0 \
    libboost-chrono1.74.0 \
    libdb5.3++ \
    libzmq5 \
    libminiupnpc17 \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bin/auroracoind /usr/local/bin/auroracoind
COPY --from=builder /usr/local/bin/auroracoin-cli /usr/local/bin/auroracoin-cli
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /data/.auroracoin
VOLUME ["/data/.auroracoin"]
EXPOSE 12340 12341

ENTRYPOINT ["/entrypoint.sh"]
CMD ["auroracoind", "-datadir=/data/.auroracoin", "-conf=/data/.auroracoin/auroracoin.conf", "-printtoconsole"]
