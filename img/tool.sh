#!/bin/bash
CA=/etc/openvpn/rsa

cd "$CA"

function init_ca {
    cp -ra /usr/share/easy-rsa/* .
    cp openssl-1.0.0.cnf openssl.cnf
    echo ""
    echo "You can now open another terminal and edit the 'conf/rsa/vars' file to fit your need."
    echo "This step is optional, just skip it if you have no idea what it is."
    echo ""
    echo "After you are prepared, press Enter to continue..."
    read a
    source ./vars

    ./clean-all

    # generate ca
    ./pkitool --initca --batch
    ./build-dh

    # generate server key
    ./pkitool --server --batch server
}

function gen {
    source ./vars
    if [[ $1 == "" ]]
    then
	echo "You must provide client key-file name"
	return 1
    fi

    ./pkitool --batch "$1"
}

function help {
    echo "Usage: $0 command [arguments]"
    echo ""
    echo "Supported commands:"
    echo "  init:    Initialize ca directory"
    echo "  gen:     Generate a client key, require key-file name as only argument"
    echo ""
    echo "Example:"
    echo "  $0 init"
    echo "  $0 gen john"
}

case "$1" in
    init)
	mkdir -p "$CA"
	cd "$CA"
	init_ca
	;;
    gen)
	cd "$CA"
	gen "$2"
	;;
    *)
	help
	;;
esac
