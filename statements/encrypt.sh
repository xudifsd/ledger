#!/bin/bash

USAGE="Usage $0 [en|de] file"
action=

if [ "$#" -eq 0 ] ; then
    echo "Usage $0 [en|de]" >&2
    exit 1
else
    action=$1
fi

if [ "x$action" == "xen" ]; then
    if [ "$#" -eq 1 ] ; then
        for i in `find . -type f -regex ".*.pdf"` ; do
            prefix=${i%%".pdf"}
            cat $i | gpg2 --recipient 1D633371CAFD6E1E46CEA746346561A8EEF40745 --armor --encrypt > $prefix.gpg
            shred -u $i
        done
    else
        echo $USAGE >&2
        exit 2
    fi
elif [ "x$action" == "xde" ]; then
    if [ "$#" -eq 1 ] ; then
        for i in `find . -type f -regex ".*.gpg"` ; do
            prefix=${i%%".gpg"}
            if [ -e $prefix.pdf ] ; then
                echo "$prefix.pdf exist, please remove to decrypt"
            else
                cat $i | gpg2 --decrypt > $prefix.pdf
            fi
        done
    else
        prefix=${2%%".gpg"}
        cat $2 | gpg2 --decrypt > $prefix.pdf
    fi
else
    echo $USAGE >&2
    exit 3
fi
