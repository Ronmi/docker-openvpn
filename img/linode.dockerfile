FROM debian:latest

RUN echo 'deb http://mirrors.linode.com/debian/ stable main' > /etc/apt/sources.list \
 && echo 'deb http://mirrors.linode.com/debian-security/ stable/updates main' >> /etc/apt/sources.list

RUN apt-get update \
 && apt-get install -y --no-install-recommends openvpn openvpn-blacklist openssl easy-rsa iptables \
 && apt-get clean -y \
 && rm -fr /var/lib/apt/lists/*

ADD tool.sh /usr/local/bin/
ADD start.sh /

CMD ["/start.sh"]