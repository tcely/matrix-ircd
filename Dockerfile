FROM rust:1-slim AS builder
RUN apt-get update && apt-get -y install ca-certificates libssl-dev pkg-config
WORKDIR /usr/src/matrix-ircd
COPY . .
RUN cargo install --path .

FROM debian:stable-slim
RUN apt-get update && apt-get -y install ca-certificates libssl1.1 && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/matrix-ircd /usr/local/bin/
EXPOSE 5999/tcp
ENTRYPOINT ["/usr/local/bin/matrix-ircd"]
