# Build Stage
FROM rust:1.48.0 AS builder
WORKDIR /usr/src/

RUN USER=root cargo new builder
WORKDIR /usr/src/builder
COPY Cargo.toml Cargo.lock ./
RUN cargo build --release

COPY src ./src
RUN cargo install --path .

# Bundle Stage
FROM gcr.io/distroless/cc
COPY --from=builder /usr/local/cargo/bin/flayers /bin/sh
ENTRYPOINT [ "/bin/sh" ]
