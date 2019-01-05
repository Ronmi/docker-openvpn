FROM debian:stable-slim

RUN echo 'deb http://mirrors.linode.com/debian/ stable main' > /etc/apt/sources.list \
 && echo 'deb http://mirrors.linode.com/debian-security/ stable/updates main' >> /etc/apt/sources.list

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends openvpn openssl easy-rsa iptables \
 && apt-get clean -y \
 && rm -fr /var/lib/apt/lists/*

ADD tool.sh /usr/local/bin/
ADD start.sh /
ADD upgrade.sh /

CMD ["/start.sh"]
