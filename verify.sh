certificados.php:			$salida = shell_exec('openssl pkcs8 -inform DER -in '.$nombreKey.' -out '.$nombreKey.'.pem -passin pass:'.$password.' 2>&1');
certificados.php:			$salida = shell_exec('openssl x509 -inform DER -outform PEM -in '.$nombreCer.' -pubkey -out '.$nombreCer.'.pem 2>&1');
certificados.php:			$salida = shell_exec('echo 4xBbCfSj | sudo -S openssl pkcs12 -export -inkey '.$nombreKeyPem.' -in '.$nombreCerPem.' -out '.$pfx.' -passout pass:'.$password.' 2>&1');
certificados.php:			$salida = shell_exec('openssl x509 -in '.$nombreCerPem.' -noout -serial  2>&1');
certificados.php:			$salida = shell_exec('openssl x509 -in '.$nombreCerPem.' -noout -startdate 2>&1');
certificados.php:			$salida = shell_exec('openssl x509 -in '.$nombreCerPem.' -noout -enddate 2>&1');
certificados.php:			$salida = shell_exec('openssl x509 -in '.$nombreCerPem.' -noout -subject 2>&1');
certificados.php:			$salidaCer = shell_exec('openssl x509 -noout -modulus -in '.$nombreCerPem.' 2>&1');
certificados.php:			$salidaKey = shell_exec('openssl rsa -noout -modulus -in '.$nombreKeyPem.' 2>&1');
README.md:certificados-sat-openssl
