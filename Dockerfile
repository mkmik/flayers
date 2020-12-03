# syntax = docker/dockerfile:1-experimental

# Build Stage
FROM rust:1.48.0 AS builder

ENV CARGO_TARGET_DIR=/tmp/target
ENV CARGO_HOME=/tmp/cargo
RUN rustup target add x86_64-unknown-linux-musl

ENV BIN=flayers

WORKDIR /usr/src/

RUN USER=root cargo new builder
WORKDIR /usr/src/builder

COPY . .

RUN --mount=type=cache,target=/tmp/cargo \
    --mount=type=cache,target=/tmp/target \
    cargo build --release && \
    cp ${CARGO_TARGET_DIR}/release/${BIN} /bin/

# Bundle Stage
FROM gcr.io/distroless/cc
COPY --from=builder /bin/flayers /bin/sh
ENTRYPOINT [ "/bin/sh" ]
