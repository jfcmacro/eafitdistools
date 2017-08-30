#!/bin/env bash

#
# created: 11/08/2017
# user: Juan Francisco Cardona Mc'Cormick (jfcmacro)
# purpose: This program create a directory hierarchy
#
# Modifications:
# 30/08/2017 - Updating 
# 26/08/2017 - Generalizing the script in order to manage diferents OS.
#

function tolower {
    local mytolower=$(echo $1 | tr '[:upper:]' '[:lower:]')
    echo "$mytolower"
}

if [ ! -f $HOME/.edtrc ]; then
    echo "$HOME/.edtrc doesn't exists, please execute edtinit" 2>&1
    exit 1
else
    source $HOME/.edtrc
fi

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

echo "Printing resume"
echo "course: $COURSE"
echo "username: $USERNAME"
echo "courselower: $COURSELOWER"
echo "reponame: $REPONAME"
echo "urlbase: $URLBASE"
echo "urlversioncontrol: $URLVERSIONCONTROL"

cd $HOME/$COURSELOWER

if [ -n "${REPONAME}" ]
then
    svn co $URLVERSIONCONTROL/$REPONAME --username $USERNAME
fi

if [ "$?" -ne 0 ]
then
    echo "You don't have a repository, please add one"
    exit 1
fi
