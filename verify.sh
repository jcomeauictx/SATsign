#!/bin/bash
openssl pkcs8 -inform DER -in $KEYFILE -out $KEYFILE.pem -passin pass:$SATPASS
openssl x509 -inform DER -outform PEM -in $CERTFILE -pubkey -out $CERTFILE.pem
echo 4xBbCfSj | openssl pkcs12 -export -inkey $KEYFILE.pem -in $CERTFILE.pem -out $KEYFILE.pfx -passout pass:$SATPASS
openssl x509 -in $CERTFILE.pem -noout -serial
openssl x509 -in $CERTFILE.pem -noout -startdate
openssl x509 -in $CERTFILE.pem -noout -enddate
openssl x509 -in $CERTFILE.pem -noout -subject
modcert=$(openssl x509 -noout -modulus -in $CERTFILE.pem)
modkey=$(openssl rsa -noout -modulus -in $KEYFILE.pem)
if [ -n "$modcert" ]; then
	if [ "$modcert" = "$modkey" ]; then
		echo certificate and key match
	else
		echo certificate and key do not match
		exit 1
	fi
else
	echo could not find modulus of certificate and/or key
	exit 1
fi
