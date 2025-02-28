SHELL := /bin/bash
SATDIR ?= $(word 1, $(wildcard $(HOME)/FIEL_* $(HOME)/*/FIEL_* /mnt/FIEL_* \
 /mnt/*/FIEL_*))
KEYFILE ?= $(wildcard $(SATDIR)/Claveprivada_FIEL_*.key)
CERTFILE ?= $(wildcard $(SATDIR)/*.cer)
SATPASS ?= pUtPa55w0rDh3rE
TRUSTLIST ?= $(HOME)/.gnupg/trustlist.txt
export KEYFILE CERTFILE SATPASS
# or better, from command line, type a space (to keep plaintext out of
# history file), then: export SATPASS=MySecretPassword
# NOTE: don't actually use MySecretPassword! type your own instead!
# and when you're done with your SAT files, `unset SATPASS`
all: initialize importcerts trust test
initialize: $(KEYFILE).pfx
$(KEYFILE).pfx: verify.sh
	@echo location of files: $(SATDIR)
	@echo key file: $(KEYFILE)
	@echo certificate file: $(CERTFILE)
	@echo password: $(SATPASS)
	bash $<
trust: trustlist.txt
	while read line; do \
	 if [ -e $(TRUSTLIST) ] && grep -q "$$line" $(TRUSTLIST); then \
	  echo $$line already trusted; \
	 else echo $$line >>$(TRUSTLIST) && echo $$line now trusted; \
	 fi; \
	done < $<
test: /tmp/test.txt.signed
importcerts: $(KEYFILE).pfx
	gpgsm --import $<
	gpgsm --import sat.certs/*.{crt,cer}
unimportcerts:
	# NOTE: disabled by default!
	# it will delete all gpgsm certificates and private keys!
	false  # NOTE: remove this at your peril!
	gpgsm --delete-keys $$(gpgsm --list-keys \
	 | awk '$$1 ~ /^ID:/ {print $$2}')
/tmp/test.txt:
	echo testing, testing, one two three... > $@
%.txt.signed: %.txt
	gpgsm --sign $< >$@
%.pdf.signed: %.pdf
	gpgsm --sign $< >$@
