SHELL := /bin/bash

ALL:

de:
	@for i in `find . -type f -regex ".*.gpg" -not -path ".*/statements/*"` ; do \
		prefix=$${i%%".gpg"} ; \
		if [ -e $$prefix.beancount ] ; then \
			echo "$$prefix.beancount exist, please remove to decrypt" ; \
		else \
			cat $$i | gpg2 --decrypt > $$prefix.beancount ; \
		fi \
	done

en:
	@for i in `find . -type f -regex ".*.beancount" -not -path ".*/statements/*"` ; do \
		prefix=$${i%%".beancount"} ; \
		diff <(cat $$prefix.gpg | gpg2 --decrypt 2>/dev/null) <(cat $$i) ; \
		result=$$? ; \
		if [ $$result -eq 1 ] ; then \
			cat $$i | gpg2 --recipient 1D633371CAFD6E1E46CEA746346561A8EEF40745 --armor --encrypt > $$prefix.gpg ; \
		fi ; \
		shred -u $$i ; \
	done

push: en
	@for i in `find . -type f -regex ".*.gpg" ` ; do \
		git add $$i ; \
	done
	git commit -m add
	git push origin master
