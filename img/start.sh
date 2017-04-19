#!/bin/bash

cfg=$(cat /etc/openvpn/server.conf|grep -E '^server ')
ip=$(echo "$cfg"|grep -oE '[0-9.]+'|head -n 1)
mask=$(echo "$cfg"|grep -oE '[0-9.]+'|head -n 2|tail -n 1)
iptables -t nat -A POSTROUTING -s $ip/$mask ! -d $ip/$mask -j MASQUERADE

exec openvpn --cd /etc/openvpn --config /etc/openvpn/server.conf --log /dev/stderr
