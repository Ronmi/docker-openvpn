FROM arm32v7/debian:stable-slim

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends openvpn openssl easy-rsa iptables \
 && apt-get clean -y \
 && rm -fr /var/lib/apt/lists/*

ADD tool.sh /usr/local/bin/
ADD start.sh /
ADD upgrade.sh /

CMD ["/start.sh"]
