certificados-sat-openssl
========================

Manejo de certificados y sello digital SAT - PHP

- Permite crear archivos key.pem
- Permite crear archivos cer.pem
- Permite crear archivos .pfx
- Obtiene fecha de inicio del certificado
- Obtiene fecha de vigencia del certificado
- Obtiene numero de seria del certificado
- Permite verificar si un certificado no es una fiel
- Verifica que el certificado(.cer) sea pareja de la llave(.key)

# notes for English-speaking users

* I just grepped the openssl calls out of the php file and made a bash script
* I don´t know what the .pfx file is for, and am not curious enough to google it
* If the password you gave SAT doesn't work, maybe they upcased or swapcased it
  (they swapcased mine; either that or the caps lock was on when I typed it,
   and I wasn´t allowed to see what I was typing)
* typing `make` will do all that the php script does
* the results will be found in the directory where the original files from
  SAT were stored, e.g. /mnt/usb/FIEL_ABCD950505XY9_20250225093522/
