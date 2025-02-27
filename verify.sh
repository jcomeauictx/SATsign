#!/bin/bash
if [ -e "$KEYFILE" ] && [ -e $CERTFILE ]; then
	echo found $KEYFILE and $CERTFILE
else
	echo did not find one or more necessary files >&2
	exit 1
fi
if [ -z "$SATPASS" ] || [ $SATPASS = "pUtPa55w0rDh3rE" ] \
	|| [ $SATPASS = "MySecretPassword" ]; then
	echo invalid password, please read the Makefile >&2
	exit 1
fi
openssl pkcs8 -inform DER -in $KEYFILE -out $KEYFILE.pem -passin pass:$SATPASS
openssl x509 -inform DER -outform PEM -in $CERTFILE -pubkey -out $CERTFILE.pem
echo 4xBbCfSj | openssl pkcs12 -export -inkey $KEYFILE.pem -in $CERTFILE.pem -out $KEYFILE.pfx -passout pass:$SATPASS
openssl x509 -in $CERTFILE.pem -noout -serial
openssl x509 -in $CERTFILE.pem -noout -startdate
openssl x509 -in $CERTFILE.pem -noout -enddate
openssl x509 -in $CERTFILE.pem -noout -subject
# generate pkcs12 combined cert and key for gpgsm
# https://stackoverflow.com/a/62613267/493161
openssl pkcs12 -export -in $CERTFILE.pem -inkey $KEYFILE.pem -out $KEYFILE.p12
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
