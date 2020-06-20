FROM debian:latest as builder
MAINTAINER Santic <admin@santic-zombie.ru>

RUN apt-get update && apt-get install -y git libcurl4-gnutls-dev \
    build-essential libsdl2-dev zlib1g-dev && \
    git clone https://github.com/skullernet/q2pro && \
    git clone https://github.com/skullernet/openffa && \
    git clone https://github.com/skullernet/opentdm

COPY config /q2pro/.config
WORKDIR /q2pro
RUN make

WORKDIR /openffa
RUN make

WORKDIR /opentdm
RUN make


FROM debian:latest

RUN useradd -m -s /bin/bash quake2 && \
    mkdir -p /usr/local/lib/games/q2pro/baseq2 && \
    mkdir -p /usr/local/lib/games/q2pro/openffa && \
    mkdir -p /usr/local/lib/games/q2pro/opentdm

    
COPY --from=builder /q2pro/gamex86_64.so \
                    /usr/local/lib/games/q2pro/baseq2/gamex86_64.so
COPY --from=builder /openffa/gamex86_64.so \
                    /usr/local/lib/games/q2pro/openffa/gamex86_64.so
COPY --from=builder /opentdm/gamex86_64.so \
                    /usr/local/lib/games/q2pro/opentdm/gamex86_64.so
COPY --from=builder /q2pro/q2proded /usr/local/bin

EXPOSE 27910/udp

USER quake2

ENTRYPOINT ["q2proded"]


