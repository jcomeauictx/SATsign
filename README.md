certificados-sat-openssl
========================

Manejo de certificados y sello digital SAT

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
* the .pfx file is to import into gpgsm for signing. could also name as .p12
* If the password you gave SAT doesn't work, maybe they upcased or swapcased it
  (they swapcased mine; either that or the caps lock was on when I typed it,
   and I wasn´t allowed to see what I was typing)
* typing `make` will do all that the php script does
* the results will be found in the directory where the original files from
  SAT were stored, e.g. /mnt/usb/FIEL_ABCD950505XY9_20250225093522/
* for use with PGP: <https://stackoverflow.com/a/62613267/493161>
* parent certs for potential use with pgpsm signing can be found at 
  <http://omawww.sat.gob.mx/tramitesyservicios/Paginas/certificado_sello_digital.htm> and
  <https://www.cloudb.sat.gob.mx/TSP_MX.pdf>; these are now imported into gpgsm
  by default.
* using detached signatures after finding that nothing can read signed txt
  files, and though browsers can mostly view signed PDFs they aren't able to
  detect nor verify the signatures.
* [build complete chain in pfx/p12 file](https://serverfault.com/a/1011396/58945)
