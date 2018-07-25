#!/usr/bin/env bash

#
# Created: 05/02/2018
# Programmer: Juan Francisco Cardona Mc'Cormick (jfcmacro)
# purpose: Re-run edt_init_script.sh
#
# Modifications:
# (jfcmacro)
# 08/02/2018 - Adding version

function tolower {
    local mytolower=$(echo $1 | tr '[:upper:]' '[:lower:]')
    echo "$mytolower"
}

function createDir {
    if [ ! -d $1 ]
    then
	mkdir $1
    fi
}

function printVersion {
    printf "EafitDisTools ($1) Version: $2\n"
    exit 0
}

version=EDTPACKAGE

OSNAME=`uname -s`
USERNAME=`id -un`

COURSE=$EDT_CURRENT_COURSE
COURSELOWER=$(tolower $COURSE)
tmp="EDT_${COURSE}_REPONAME"
eval REPONAME='$'$tmp
tmp="EDT_${COURSE}_USERNAME"
eval USERNAME='$'$tmp
tmp="EDT_${COURSE}_URL_BASE"
eval URLBASE='$'$tmp
tmp="EDT_${COURSE}_URL_VERSION_CONTROL"
eval URLVERSIONCONTROL='$'$tmp

longprogname=$0
progname=$(basename $longprogname)

while getopts "v" opt; do
    case $opt in
        v)
            printVersion $progname $version
            ;;
    esac
done

URLINITSCRIPT=$URLBASE/courses/$COURSELOWER/edt_init_script.sh

cd $HOME
echo "Getting url $URLINITSCRIPT"

if [[ `wget -S --spider $URLINITSCRIPT  2>&1 | grep 'HTTP/1.1 200 OK'` ]]
then
    
    wget $URLINITSCRIPT -O edt_init_script.sh

    if [ -f edt_init_script.sh ]; then
        echo "Executing edt_init_script.sh"
        bash $HOME/edt_init_script.sh
        rm -f edt_init_script.sh
    fi
else
    echo "edt_init_script.sh cannot be download"
fi

createDir $COURSELOWER

for i in $HOME/edt_init_script.*
do
    if [ -f $i ]; then
        rm -f $i
    fi
done
