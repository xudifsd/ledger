#!/bin/bash

action=

if [ "$#" -eq 0 ] ; then
    echo "Usage $0 [en|de]" >&2
    exit 1
elif [ "$#" -eq 1 ] ; then
    action=$1
else
    echo "Usage $0 [en|de]" >&2
    exit 2
fi

if [ "x$action" == "xen" ]; then
    for i in `ls *.pdf` ; do
        prefix=${i%%".pdf"}
        cat $i | gpg --default-recipient-self --armor --encrypt > $prefix.gpg
        shred -u $i
    done
else
    for i in `ls *.gpg` ; do
        prefix=${i%%".gpg"}
        if [ -e $prefix.pdf ] ; then
            echo "$prefix.pdf exist, please remove to decrypt"
        else
            cat $i | gpg --decrypt > $prefix.pdf
        fi
    done
fi
