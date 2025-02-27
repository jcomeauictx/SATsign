#!/bin/bash
openssl pkcs8 -inform DER -in $KEYFILE -out $KEYFILE.pem -passin pass:$SATPASS
openssl x509 -inform DER -outform PEM -in $CERTFILE -pubkey -out $CERTFILE.pem
if false; then
	echo 4xBbCfSj | openssl pkcs12 -export -inkey $KEYFILE.pem -in $CERTFILE.pem -out $KEYFILE.pfx -passout pass:$SATPASS
	openssl x509 -in $CERTFILE.pem -noout -serial
	openssl x509 -in $CERTFILE.pem -noout -startdate
	openssl x509 -in $CERTFILE.pem -noout -enddate
	openssl x509 -in $CERTFILE.pem -noout -subject
	openssl x509 -noout -modulus -in $CERTFILE.pem
	openssl rsa -noout -modulus -in $KEYFILE.pem
fi
