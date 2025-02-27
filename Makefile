SATDIR ?= $(word 1, $(wildcard $(HOME)/FIEL_* $(HOME)/*/FIEL_* /mnt/FIEL_* \
 /mnt/*/FIEL_*))
KEYFILE ?= $(wildcard $(SATDIR)/Claveprivada_FIEL_*.key)
CERTFILE ?= $(wildcard $(SATDIR)/*.cer)
SATPASS ?= pUtPa55w0rDh3rE
export KEYFILE CERTFILE SATPASS
# or better, from command line, type a space (to keep plaintext out of
# history file), then: export SATPASS=MySecretPassword
# NOTE: don't actually use MySecretPassword! type your own instead!
# and when you're done with your SAT files, `unset SATPASS`
all:
	@echo location of files: $(SATDIR)
	@echo key file: $(KEYFILE)
	@echo certificate file: $(CERTFILE)
	@echo password: $(SATPASS)
	bash verify.sh
