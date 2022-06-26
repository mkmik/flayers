# syntax = docker/dockerfile:1-experimental

# Build Stage
FROM clux/muslrust:1.61.0@sha256:56d9528556af783db7c50f77517ce998e4623a93803d53ba28df835158ec3b4f AS builder

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
FROM gcr.io/distroless/static@sha256:2ad95019a0cbf07e0f917134f97dd859aaccc09258eb94edcb91674b3c1f448f
COPY --from=builder /out/ /bin/
ENTRYPOINT [ "/bin/flayers" ]



