#!/bin/bash

apt-get update
apt-get -y upgrade
rm -fr /var/lib/apt/lists/*
