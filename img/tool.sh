#!/bin/bash
CA=/etc/openvpn/rsa

cd "$CA"

function init_ca {
    cp -ra /usr/share/easy-rsa/* .
    echo ""
    echo "please edit the 'vars' file to fitt your need."
    echo "After finish editing, press Enter to continue..."
    read a
    source ./vars

    ./clean-all

    echo "Press Enter to generate ca files"
    read a
    ./build-ca
    ./build-dh

    echo "PressEnter to generate server key"
    read a
    ./build-key-server server
}

function gen {
    source ./vars
    if [[ $1 == "" ]]
    then
	echo "You must provide client key-file name"
	return 1
    fi

    ./build-key "$1"
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
	init_ca
	;;
    gen)
	gen "$2"
	;;
    *)
	help
	;;
esac
