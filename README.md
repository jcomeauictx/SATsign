# certificados-sat-openssl
========================

## Manejo de certificados y sello digital SAT

- Permite crear archivos key.pem
- Permite crear archivos cer.pem
- Permite crear archivos .pfx
- Obtiene fecha de inicio del certificado
- Obtiene fecha de vigencia del certificado
- Obtiene numero de seria del certificado
- Permite verificar si un certificado no es una fiel
- Verifica que el certificado(.cer) sea pareja de la llave(.key)

## Management of SAT certificates and digital signatures

(SAT is the Mexican equivalent of the IRS. When you obtain a CFR (tax ID,
required for opening a Mexican bank account and for other purposes), they
ask for a thumb drive on which they store a certificate and key. You can
use these for signing documents to be sent to SAT. They aren't of much use
generally, as the cert chain only goes to the Banco de Mexico, which has
a self-signed CAcert not recognized by any major operating systems or web
browsers).

You can:
- Unlock (remove password from) your .key file and store it in a .key.pem file.
- Convert your .cer (certificate file) into .pem as well, for easier use.
- Create a .pfx file which combines the two .pem files, useful for
  digital signatures.
- Ascertain that the certificate and key match.
- Make sure that the certificate chain is complete.

To do all the above, usually you can simply type the command `make` from this
directory, as long as your thumb drive is plugged in or you've copied the
`FIEL_*` directory from it into your home directory. The .pem and .pfx files
will be stored in that same FIEL_* subdirectory.

- view your certificate's serial number, start date, end date, and subject

`make info` does this. The "subject" includes your ALL CAPS NAME,
x500UniqueIdentifier which is your RFC number, and serialNumber which
is your CURP (another identication number used by the Mexican government).

You may note something odd about the serial number; every group of two digits
starts with a 3. This means that the actual number has been encoded in
hexadecimal for reasons unknown to me. To see the real number, use
`make serial`, but everything I've seen so far indicates that the hex-encoded
serial number is what SAT uses. (Update: running `strings` on the binary .cer
file reveals the real serial number as well; it's openssl changing it to
hex-encoded.)

### Advanced use

To use the cert to sign a document, assuming you're running Debian
GNU/Linux or similar, you'll need to install libreoffice-common, gpgsm,
and firefox.

Then, once you have done the steps below regarding firefox and loffice
(libreoffice), you can:

* for a file /tmp/myfile.pdf, you can `make /tmp/myfile.signed.pdf`; this
  will use LibreOffice in silent (no GUI) mode to sign the PDF.

Read the developer's notes below, and the Makefile, to see more details
about how this works, and what other things can be done, including the use
of gpgsm.

## developer's notes

* I just grepped the openssl calls out of Christian's php file and made
  a bash script
* The .pfx file is to import into gpgsm for signing. could also name as .p12
* If the password you gave SAT doesn't work, maybe they upcased or swapcased
  it (they swapcased mine; either that or the caps lock was on when I typed
  it, and I wasn't allowed to see what I was typing)
* Typing `make` will do all that the php script does
* The results will be found in the directory where the original files from
  SAT were stored, e.g. /mnt/usb/FIEL_ABCD950505XY9_20250225093522/
* For use with PGP: <https://stackoverflow.com/a/62613267/493161>
* Parent certs for potential use with pgpsm signing can be found at 
  <http://omawww.sat.gob.mx/tramitesyservicios/Paginas/certificado_sello_digital.htm> and
  <https://www.cloudb.sat.gob.mx/TSP_MX.pdf>; these are now imported into gpgsm
  by default.
* Using detached signatures after finding that nothing can read signed txt
  files, and though browsers can mostly view signed PDFs they aren't able to
  detect nor verify the signatures.
* [Build complete chain in pfx/p12 file](https://serverfault.com/a/1011396/58945) (had to run `openssl rehash -compat .` inside sat.certs directory first).
* For use with Firefox and LibreOffice, first set up a separate profile
  (I called mine SAT) by starting firefox with the -ProfileManager option.
* In firefox, click "hamburger" icon at upper right for settings, then
  Privacy & Security | Certificates | View Certificates |
  Your Certificates | Import
  Locate the pfx file and import it; you will see it imports your key under
  Your Certificates, and *also* imports the SAT cert, and the self-signed
  Banco de Mexico root certificate, under Authorities.
  However, neither are yet trusted. You need to select BANCO DE MEXICO, then
  click the Edit Trust button, and enable it to identify both websites and
  email users. Do the same for SAT (AC DEL SERVICIO DE ADMINISTRACION
  TRIBUTARIA), except it only needs to verify email users.
  Click the OK button in Certificate Manager to close it.
* In loffice, select Tools | Options | LibreOffice | Security | Certificate,
  and choose the firefox:SAT profile you just made. Then, from
  File | Digital Signatures | Digital Signatures, you can sign a PDF document.
  It will show that the signature is valid.
* [Signing from command line](https://help.libreoffice.org/
  latest/he/text/shared/guide/pdf_params.html), [and more details](https://
  vmiklos.hu/blog/pdf-convert-to.html) (now incorporated into Makefile:
  `make /path/to/mydoc.signed.pdf`)
