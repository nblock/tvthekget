#!/bin/bash
# tvthekget.sh - grab videos from tvthek.orf.at
# author: nblock <nblock [at] archlinux [dot] us>
# license: GPLv3
# TODO:
#  -add multiple url support
#  -name files according to the name of the report instead of using a counter
#  -some more testing

TMP=/tmp/tvthekgetlinks
TVTHEKBASE="http://tvthek.orf.at"
CURL="/usr/bin/curl -s"
MMSRIP="/usr/bin/mmsrip"

URL=${TVTHEKBASE}`$CURL $1 |sed -n 's/.*src="\([^"].*asx\)"/\1/p'`
$CURL $URL| grep -o 'mms:[^?"]*' > $TMP

let CTR=1
for link in $(cat $TMP)
do
    #echo "downloading:" $CTR".wmv from" $link 
    $MMSRIP -o $CTR.wmv $link
    let CTR++
done

rm $TMP

# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
