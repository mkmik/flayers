# syntax = docker/dockerfile:1-experimental

# Build Stage
FROM clux/muslrust:1.59.0@sha256:b0a1de4e65bbefb1f49d344b684d4a8bf0f02b9f332a4adc1552dee192b2d1ed AS builder

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
FROM gcr.io/distroless/static@sha256:8ad6f3ec70dad966479b9fb48da991138c72ba969859098ec689d1450c2e6c97
COPY --from=builder /out/ /bin/
ENTRYPOINT [ "/bin/flayers" ]



