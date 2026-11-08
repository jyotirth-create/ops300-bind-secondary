
FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bind9 bind9-utils dnsutils ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/cache/bind /run/named \
    && chown -R bind:bind /var/cache/bind /run/named

EXPOSE 53/tcp 53/udp

CMD ["named", "-g", "-u", "bind"]
