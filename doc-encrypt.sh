#!/bin/bash

USAGE="Usage $0 [en|de] dir"
action=

if [ "$#" -eq 0 ] ; then
    echo $USAGE >&2
    exit 1
else
    action=$1
fi

if [ "x$action" == "xen" ]; then
    if [ "$#" -eq 1 ] ; then
        for i in `find . -type f -regex ".*.pdf"` ; do
            prefix=${i%%".pdf"}
            diff <(cat $i) <(cat $prefix.gpg | gpg2 --decrypt 2>/dev/null)
            result=$?
            if [ $result -eq 1 ] ; then
                cat $i | gpg2 --recipient 1D633371CAFD6E1E46CEA746346561A8EEF40745 --armor --encrypt > $prefix.gpg
            fi
            shred -u $i
        done
    else
        echo $USAGE >&2
        exit 2
    fi
elif [ "x$action" == "xde" ]; then
    if [ "$#" -eq 2 ] ; then
        for i in `find $2 -type f -regex ".*.gpg"` ; do
            prefix=${i%%".gpg"}
            if [ -e $prefix.pdf ] ; then
                echo "$prefix.pdf exist, please remove to decrypt"
            else
                cat $i | gpg2 --decrypt > $prefix.pdf
            fi
        done
    else
        echo $USAGE >&2
        exit 2
    fi
else
    echo $USAGE >&2
    exit 3
fi
