SHELL := /bin/bash
KEYFILE ?= $(wildcard *Key.der)
CERTFILE ?= $(wildcard certificate.der)
SOFFICE ?= $(wildcard ../../libreoffice-core/instdir/program/soffice
ifeq ($(SHOWENV),)
 export KEYFILE CERTFILE SATPASS
else
 export
endif
all: initialize test.txt test.signed.pdf
initialize: $(KEYFILE).pfx
SUBJECT := $(shell openssl x509 -in $(CERTFILE) -noout -subject \
	 -nameopt RFC2253 | sed 's/^subject=//')
test.txt:
	echo testing, testing, one two three... > $@
%.signed.pdf: %.txt
	subject="$$($(MAKE) -s subject)" && \
	$(SOFFICE) --invisible --convert-to pdf:\"draw_pdf_Export\":{\
	 \"SignPDF\":{\"type\":"\boolean\",\"value\":\"true\"},\
	 \"SignCertificateSubjectName\":{\
	 \"type\":\"string\",\"value\":\"$$subject\"\
	}}" $< --outdir ${@D}
env:
ifeq ($(SHOWENV),)
	$(MAKE) SHOWENV=1 $@
else
	$@
endif
$(KEYFILE).pem: $(KEYFILE)
	openssl pkcs8 -inform DER -in $< -out $@
$(CERTFILE).pem: $(CERTFILE)
	openssl x509 -inform DER -in $< -pubkey -out $@
$(KEYFILE).pfx: $(KEYFILE).pem $(CERTFILE).pem
	# generate pkcs12 combined cert and key for gpgsm and libreoffice
	# https://stackoverflow.com/a/62613267/493161
	# https://serverfault.com/a/1011396/58945
	echo 'Just hit the <ENTER> key at password prompts below' >&2
	openssl verify -verbose -show_chain -CApath . $(word 2, $+)
	openssl pkcs12 -export -inkey $< -in $(word 2, $+) \
	 -out $@ -legacy -chain -CApath .
