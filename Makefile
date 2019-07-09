SHELL := /bin/bash

ALL:

edit:
	vim -c "set filetype=beancount" main.gpg

de:
	gpg --decrypt main.gpg 2>/dev/null > main.beancount
	-@PROMPT_COMMAND="PS1=`echo 'safemode$$ '`" bash --norc --noprofile
	shred -u main.beancount
