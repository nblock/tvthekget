#!/bin/bash
# tvthekget.sh - grab videos from tvthek.orf.at
# author: nblock <nblock [at] archlinux [dot] us>
# license: GPLv3
# TODO:
#  -some more testing
#  -link selection

TVTHEKBASE="http://tvthek.orf.at"
SEP="_"
CURL="/usr/bin/curl -s"
MMSRIP="/usr/bin/mmsrip"

#do the actual work
function get_files {
    URL=${TVTHEKBASE}`$CURL $1 |sed -n 's/.*src="\([^"].*asx\)"/\1/p'`
    $CURL $URL| grep -o 'mms:[^?"]*' | uniq > $TMP

    let CTR=1   #only used to preserve the order of multiple streams
    for link in $(cat $TMP); do
        DATE=`echo $link |cut -d '_' -f 1 |cut -d '/' -f 5`
        TIME=`echo $link |cut -d '_' -f 2`
        TITLE=`echo $link |cut -d '_' -f 5`
        TITLE2=`echo $link |cut -d '_' -f 6`

        if [ "x$TITLE2" != "x" ]; then
            FILE="$TITLE$SEP$DATE$SEP$TIME$SEP$CTR$SEP$TITLE2.wmv"
        else
            FILE="$TITLE$SEP$DATE$SEP$TIME.wmv"
        fi
        if [ -e $FILE ]; then
            echo "$FILE already exists. Aborting."
            exit -1
        fi
        $MMSRIP -o $FILE $link
        let CTR++
    done

    rm $TMP
}

#handle multiple parameters
while [ -n "$1" ]; do
    if [[ `echo $1 | egrep "^$TVTHEKBASE" |wc -l` -eq 1 ]]; then
        TMP=`mktemp /tmp/tvthekget.XXXXXX` || exit 1
        get_files $1
    else
        echo "$1 is an invalid argument. Skipping"
    fi
    shift
done

# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
