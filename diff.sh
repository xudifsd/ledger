#!/bin/bash

if [ "$#" -eq 0 ] ; then
    rev=HEAD^
elif [ "$#" -eq 1 ] ; then
    rev=$1
else
    echo "Usage $0 [rev]" >&2
    exit 1
fi

git rev-parse "$rev" >/dev/null 2>&1
ret=$?

if [ $ret -ne 0 ]; then
  echo "unknown revision $rev"
  exit 2
fi

for file in `find . -type f -regex ".*.gpg" -not -path ".*/statements/*"` ; do
    prefix=${file%%".gpg"} ; \
    if [ -f $prefix.beancount ] ; then
        colordiff -u \
            <(cat $file | gpg2 --decrypt 2>/dev/null) \
            <(cat $prefix.beancount)
    else
        colordiff -u \
            <(git show $rev:$file | gpg --decrypt 2>/dev/null) \
            <(cat $file | gpg2 --decrypt 2>/dev/null)
    fi
done | less -R
