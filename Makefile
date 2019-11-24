SHELL := /bin/bash

ALL:

de:
	@for i in `ls *.gpg` ; do \
		prefix=$${i%%".gpg"} ; \
		if [ -e $$prefix.beancount ] ; then \
			echo "$$prefix.beancount exist, please remove to decrypt" ; \
		else \
			cat $$i | gpg --decrypt > $$prefix.beancount ; \
		fi \
	done

en:
	@for i in `ls *.beancount` ; do \
		prefix=$${i%%".beancount"} ; \
		diff <(cat $$i) <(cat $$prefix.gpg | gpg --decrypt 2>/dev/null) ; \
		result=$$? ; \
		if [ $$result -eq 1 ] ; then \
			cat $$i | gpg --default-recipient-self --armor --encrypt > $$prefix.gpg ; \
		fi ; \
		shred -u $$i ; \
	done

push: en
	git add *.gpg
	git commit -m add
	git push origin master
