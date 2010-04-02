#!/bin/bash
# tvthekget.sh - grab videos from tvthek.orf.at
# author: nblock <nblock [at] archlinux [dot] us>
# license: GPLv3
# TODO:
#  -name files according to the name of the report instead of using a counter
#  -some more testing

TMP="/tmp/tvthekgetlinks"
TVTHEKBASE="http://tvthek.orf.at"
CURL="/usr/bin/curl -s"
MMSRIP="/usr/bin/mmsrip"

#do the actual work
function get_files {
    URL=${TVTHEKBASE}`$CURL $1 |sed -n 's/.*src="\([^"].*asx\)"/\1/p'`
    $CURL $URL| grep -o 'mms:[^?"]*' > $TMP

    let CTR=1
    for link in $(cat $TMP)
    do
        FILE="$CTR.wmv"
        if [ -e $FILE ]
        then
            echo "$FILE already exists. Aborting."
            exit -1
        fi
        #echo "downloading: $FILE from $link" 
        $MMSRIP -o $FILE $link
        let CTR++
    done

    rm $TMP
}

#handle multiple parameters
while [ -n "$1" ]
do
    get_files $1
    shift
done

# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
