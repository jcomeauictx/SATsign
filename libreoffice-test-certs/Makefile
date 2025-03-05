SHELL := /bin/bash
KEYFILE ?= $(wildcard *Key.der)
PEM_KEY := $(KEYFILE:.der=.pem)
PFX_KEY := $(KEYFILE:.der=.pfx)
CERTFILE ?= $(wildcard certificate.der)
ROOTFILES := $(wildcard *[Rr]ootCA.der)
DER_CERTS := $(KEYFILE) $(CERTFILE) $(ROOTFILES)
PEM_CERTS := $(DER_CERTS:.der=.pem)
STRACE ?= strace -o sign.log -v -f -s256
SOFFICE ?= $(wildcard ../../libreoffice-core/instdir/program/soffice)
SUBJECT := $(shell openssl x509 -in $(CERTFILE) -noout -subject \
	 -nameopt RFC2253 | sed 's/^subject=//')
CONVERT := "draw_pdf_Export":{
CONVERT := $(CONVERT)"SignPDF":{"type":"boolean","value":"true"},
CONVERT := $(CONVERT)"SignCertificateSubjectName":
CONVERT := $(CONVERT){"type":"string","value":"$(SUBJECT)"}
CONVERT := $(CONVERT)}
ifeq ($(SHOWENV),)
 export KEYFILE CERTFILE SATPASS
else
 export
endif
all: initialize test.txt test.signed.pdf
initialize: $(PFX_KEY)
test.txt:
	echo testing, testing, one two three... > $@
%.signed.pdf: %.txt
	$(STRACE) $(SOFFICE) --invisible --convert-to 'signed.pdf:$(CONVERT)' \
	 --outdir ${@D} $<
env:
ifeq ($(SHOWENV),)
	$(MAKE) SHOWENV=1 $@
else
	$@
endif
$(PEM_KEY): $(KEYFILE)
	# keyfile is not encrypted: github.com/openssl/openssl/issues/10543
	openssl pkcs8 -nocrypt -inform DER -in $< -out $@
%.pem: %.der
	openssl x509 -inform DER -in $< -pubkey -out $@
$(PFX_KEY): $(PEM_CERTS)
	# generate pkcs12 combined cert and key for gpgsm and libreoffice
	# https://stackoverflow.com/a/62613267/493161
	# https://serverfault.com/a/1011396/58945
	# rehash will error on noncompatible files, just ignore
	openssl rehash -compat . || true
	openssl verify -verbose -show_chain -CApath . $(word 2, $+)
	echo 'Just hit the <ENTER> key at password prompts below' >&2	
	openssl pkcs12 -export -inkey $< -in $(word 2, $+) \
	 -out $@ -legacy -chain -CApath .
soffice:
	$(SOFFICE)
clean:
	rm -f *.pem *.pfx *.0 test.signed.pdf test.txt *.log
