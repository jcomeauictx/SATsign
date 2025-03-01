#!/bin/bash
if [ -e "$1" ]; then
	if [ -z "$KEYFILE" ]; then
		KEYFILE=$1
	elif [ $KEYFILE != $1 ]; then
		echo keyfile from env and commandline differ >&2
		exit 1
	fi
fi
if [ -e "$2" ]; then
	if [ -z "$CERTFILE" ]; then
		CERTFILE=$2
	elif [ $CERTFILE != $2 ]; then
		echo certfile from env and commandline differ >&2
		exit 1
	fi
fi
if [ -e "$KEYFILE" ] && [ -e "$CERTFILE" ]; then
	echo found $KEYFILE and $CERTFILE
else
	echo Usage $0 keyfile certfile [satpassword] >&2
	exit 1
fi
if [ -z "$SATPASS" ] || [ $SATPASS = "pUtPa55w0rDh3rE" ] \
	|| [ $SATPASS = "MySecretPassword" ]; then
	echo invalid password, please read the Makefile >&2
	read -e -p "input correct password: " SATPASS
fi
openssl pkcs8 -inform DER -in $KEYFILE -out $KEYFILE.pem -passin pass:$SATPASS
openssl x509 -inform DER -outform PEM -in $CERTFILE -pubkey -out $CERTFILE.pem
openssl x509 -in $CERTFILE.pem -noout -serial
openssl x509 -in $CERTFILE.pem -noout -startdate
openssl x509 -in $CERTFILE.pem -noout -enddate
openssl x509 -in $CERTFILE.pem -noout -subject
modcert=$(openssl x509 -noout -modulus -in $CERTFILE.pem)
modkey=$(openssl rsa -noout -modulus -in $KEYFILE.pem)
if [ -n "$modcert" ]; then
	if [ "$modcert" = "$modkey" ]; then
		echo certificate and key match >&2
	else
		echo certificate and key do not match >&2
		exit 1
	fi
else
	echo could not find modulus of certificate and/or key >&2
	exit 1
fi
# generate pkcs12 combined cert and key for gpgsm
# https://stackoverflow.com/a/62613267/493161
# https://serverfault.com/a/1011396/58945
echo 'Just hit the <ENTER> key at password prompts below' >&2
openssl verify -verbose -show_chain -CApath sat.certs $CERTFILE.pem
openssl pkcs12 -export -inkey $KEYFILE.pem -in $CERTFILE.pem \
 -out $KEYFILE.pfx -legacy -chain -CApath sat.certs
