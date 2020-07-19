FROM ubuntu:18.04

ARG TOOLCHAIN=stable

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
        build-essential ca-certificates cmake curl git musl-dev musl-tools sudo &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN useradd rust --user-group --create-home --shell /bin/bash --groups sudo

RUN ln -s "/usr/bin/g++" "/usr/bin/musl-g++"

ADD sudoers /etc/sudoers.d/nopasswd

USER rust
RUN mkdir -p /home/rust/libs /home/rust/src

ENV PATH=/home/rust/.cargo/bin:/usr/local/musl/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- -y --default-toolchain $TOOLCHAIN && \
    rustup target add x86_64-unknown-linux-musl
ADD cargo-config.toml /home/rust/.cargo/config

