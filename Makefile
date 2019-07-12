SHELL := /bin/bash

ALL:

de:
	@for i in `ls *.gpg` ; do \
		prefix=$${i%%".gpg"} ;\
		cat $$i | gpg --decrypt > $$prefix.beancount ;\
	done

en:
	@for i in `ls *.beancount` ; do \
		prefix=$${i%%".beancount"} ;\
		cat $$i | gpg --default-recipient-self --armor --encrypt > $$prefix.gpg ;\
		shred -u $$i ;\
	done
