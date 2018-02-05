#!/usr/bin/env bash

#
# Created: 05/02/2018
# Programmer: Juan Francisco Cardona Mc'Cormick (jfcmacro)
# purpose: Re-run edt_init_script.sh

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

URLINITSCRIPT=$URLBASE/courses/$COURSELOWER/edt_init_script.sh

cd $HOME
echo "Getting url $URLINITSCRIPT"

wget $URLINITSCRIPT -O edt_init_script.sh

if [ "$?" -ne 0 ]; then
    echo "edt_init_script.sh cannot be download"
    if [ -f edt_init_script.sh ]; then
        rm -f edt_init_script.sh
    fi
else
    if [ -f edt_init_script.sh ]; then
        echo "Executing edt_init_script.sh"
        bash $HOME/edt_init_script.sh
        rm -f edt_init_script.sh
    fi
fi

createDir $COURSELOWER

for i in $HOME/edt_init_script.*
do
    if [ -f $i ]; then
        rm -f $i
    fi
done
