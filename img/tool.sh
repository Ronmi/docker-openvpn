#!/bin/bash
CA=/etc/openvpn/rsa

function init_ca {
    mkdir -p "${CA}/keys"
    chmod 700 "${CA}/keys"
    cp -ra /usr/share/easy-rsa/* .
    cp openssl-easyrsa.cnf openssl.cnf
    cp vars.example vars
    echo ""
    echo "You can now open another terminal and edit the 'conf/rsa/vars' file to fit your need."
    echo "This step is optional, just skip it if you have no idea what it is."
    echo ""
    echo "After you are prepared, press Enter to continue..."
    read a

    echo yes | ./easyrsa init-pki
    ./easyrsa gen-dh
    (echo;echo;echo;echo) | ./easyrsa build-ca nopass

    ./easyrsa build-server-full server nopass
}

function gen {
    if [[ $1 == "" ]]
    then
	echo "You must provide client key-file name"
	return 1
    fi

    ./easyrsa build-client-full "$1" nopass
}

function ovpn {
    ip="$1"
    user="$2"
    tmpf="$(mktemp)"
    grep -vE '^#' /etc/openvpn/server.conf | grep -vE '^;' > "$tmpf"

    echo 'client'
    grep -E '^dev[[:space:]]' "$tmpf"
    grep -E '^proro[[:space:]]' "$tmpf"
    port=$(grep -E '^port[[:space:]]' /etc/openvpn/server.conf|grep -oE '[[:digit:]]+')
    if [[ $port = "" ]]
    then
	port=1194
    fi
    echo "remote ${ip} ${port}"
    echo "resolv-retry infinite"
    echo "nobind"
    echo "user nobody"
    echo "group nogroup"
    grep -E '^persist-' "$tmpf"
    echo "ns-cert-type server"
    grep -E '^comp' "$tmpf"
    echo '<ca>'
    cat "${CA}/pki/issued/server.crt"
    echo '</ca>'
    echo '<cert>'
    lineno=$(grep -nE '^-----BEGIN CERTIFICATE-----$' "${CA}/pki/issued/${user}.crt"|cut -d ':' -f 1)
    cat "${CA}/pki/issued/${user}.crt" | tail -n "+${lineno}"
    echo '</cert>'
    echo '<key>'
    cat "${CA}/pki/private/${user}.key"
    echo '</key>'
}

function help {
    echo "Usage: $0 command [arguments]"
    echo ""
    echo "Supported commands:"
    echo "  init:    Initialize ca directory"
    echo "  gen:     Generate a client key, require key-file name as only argument"
    echo "  ovpn:    Generate ovpn file, need server address and key-file name"
    echo ""
    echo "Example:"
    echo "  $0 init"
    echo "  $0 gen john"
    echo "  $0 ovpn my-vpn.example.com john"
}

function check {
    if [[ ! -d "$CA" ]]
    then
	mkdir -p "$CA"
    fi

    cd "$CA"

    if [[ ! -f "${CA}/easyrsa" || ! -f "${CA}/vars" || ! -f "${CA}/openssl.cnf" ]]
    then
	init_ca
    fi
    echo ""
}

case "$1" in
    init)
	check
	;;
    gen)
	check
	cd "$CA"
	gen "$2"
	;;
    ovpn)
	check
	cd "$CA"
	if [[ ! -f "pki/private/${3}.key" || ! -f "pki/issued/${3}.crt" ]]
	then
	    gen "$3"
	    echo ""
	fi
	ovpn "$2" "$3" > "${CA}/keys/${3}.ovpn"

	echo "ovpn file generated at 'conf/rsa/keys/${3}.ovpn'"
	echo "You will need root privilege to access it."
	;;
    *)
	help
	;;
esac
