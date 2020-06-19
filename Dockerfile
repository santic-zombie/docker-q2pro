FROM debian:latest as builder
MAINTAINER Santic <admin@santic-zombie.ru>

RUN apt-get update && apt-get install git libcurl4-gnutls-dev \
    build-essential libsdl2-dev zlib1g-dev -y && \
    git clone https://github.com/skullernet/q2pro

COPY config /q2pro/.config

WORKDIR /q2pro

RUN make


FROM debian:latest

RUN useradd -m -s /bin/bash quake2 && \
    mkdir -p /usr/local/lib/games/q2pro/baseq2 && \
    mkdir -p /usr/local/share/games/q2pro/baseq2
    
COPY --from=builder /q2pro/gamex86_64.so /usr/local/lib/games/q2pro/baseq2
COPY --from=builder /q2pro/q2proded /usr/local/bin

EXPOSE 27910/udp

USER quake2

ENTRYPOINT ["q2proded"]


