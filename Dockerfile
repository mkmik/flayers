# syntax = docker/dockerfile:1-experimental

# Build Stage
FROM clux/muslrust:1.62.1@sha256:3911ecc0abebb4a3545b146a994ffeccf1773602b2c4f88353eb31d0b352cdf4 AS builder

ENV CARGO_TARGET_DIR=/tmp/target
ENV CARGO_HOME=/tmp/cargo
ENV TARGET=x86_64-unknown-linux-musl

ENV BIN=flayers

WORKDIR /usr/src/
RUN mkdir /out

RUN USER=root cargo new builder
WORKDIR /usr/src/builder

COPY . .

RUN --mount=type=cache,target=/tmp/cargo \
    --mount=type=cache,target=/tmp/target \
    cargo build --release --target ${TARGET} && \
    cp ${CARGO_TARGET_DIR}/${TARGET}/release/${BIN} /out/

# when used as:
#
#    FROM mkmik/flayers
#    RUN /layer1 /ipfs/Qm...
#
# Docker will run /bin/sh -c "/layer1 /ipfs/...."
# With this symlink we intercept that
RUN ln -s /bin/flayers /out/sh

# Bundle Stage
FROM gcr.io/distroless/static@sha256:69830f29ed7545c762777507426a412f97dad3d8d32bae3e74ad3fb6160917ea
COPY --from=builder /out/ /bin/
ENTRYPOINT [ "/bin/flayers" ]



