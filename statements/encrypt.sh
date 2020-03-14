#!/bin/bash

USAGE="Usage $0 [en|de]"
action=

if [ "$#" -eq 0 ] ; then
    echo "Usage $0 [en|de]" >&2
    exit 1
elif [ "$#" -eq 1 ] ; then
    action=$1
else
    echo $USAGE >&2
    exit 2
fi

if [ "x$action" == "xen" ]; then
    for i in `find . -type f -regex ".*.pdf"` ; do
        prefix=${i%%".pdf"}
        cat $i | gpg --default-recipient-self --armor --encrypt > $prefix.gpg
        shred -u $i
    done
elif [ "x$action" == "xde" ]; then
    for i in `find . -type f -regex ".*.gpg"` ; do
        prefix=${i%%".gpg"}
        if [ -e $prefix.pdf ] ; then
            echo "$prefix.pdf exist, please remove to decrypt"
        else
            cat $i | gpg --decrypt > $prefix.pdf
        fi
    done
else
    echo $USAGE >&2
    exit 3
fi
