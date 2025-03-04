SHELL := /bin/bash
KEYFILE ?= $(wildcard *Key.der)
CERTFILE ?= $(wildcard certificate.der)
ifeq ($(SHOWENV),)
 export KEYFILE CERTFILE SATPASS
else
 export
endif
all: initialize test.txt test.signed.pdf
initialize: $(KEYFILE).pfx
$(KEYFILE).pfx: $(KEYFILE)
SUBJECT := $(shell openssl x509 -in $(CERTFILE) -noout -subject \
	 -nameopt RFC2253 | sed 's/^subject=//')
test.txt:
	echo testing, testing, one two three... > $@
%.signed.pdf: %.txt
	subject="$$($(MAKE) -s subject)" && \
	soffice --invisible --convert-to pdf:\"draw_pdf_Export\":{\
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
