#!/usr/bin/env bash

#
# created: 11/08/2017
# user: Juan Francisco Cardona Mc'Cormick (jfcmacro)
# purpose: This program create a directory hierarchy
#
# Modifications:
# (jfcmacro)
# 02/09/2017 - Correcting the path of env instead of /usr/ it is /usr/bin
# (jfcmacro)
# 01/09/2017 - A command options were added in order to see a resumen.
#            - The default course directories were added: tmp clases
# (jfcmacro)
# 30/08/2017 - Updating
# (jfcmacro)
# 26/08/2017 - Generalizing the script in order to manage diferents OS.
#

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

function createSvnDir {
    if [ ! -d $1 ]
    then
	svn mkdir $1 
    fi
}

function helpInfo {   
    printf "options:\n" >&2
    printf "\t-h: prints the help\n"
    printf "\t-r: shows a resumen of variable values\n"
}

function usage {
    printf "\t$1 -h\n" >&2
    printf "\t$1 [-r]\n" >&2
    if [ "$2" -eq 0 ]; then
        helpInfo
    fi
    exit $2
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

longprogname=$0
progname=$(basename $longprogname)

while getopts "hr:u:n:" opt; do
    case $opt in
        h)
            usage $progname 0
            ;;
        n)
            USERNAME=$OPTARG
            ;;
        r)
            REPONAME=$OPTARG
            echo "Printing resume"
            echo "course: $COURSE"
            echo "username: $USERNAME"
            echo "courselower: $COURSELOWER"
            echo "reponame: $REPONAME"
            echo "urlbase: $URLBASE"
            echo "urlversioncontrol: $URLVERSIONCONTROL"
            ;;

        u)
            URLVERSIONCONTROL=$OPTARG
            ;;
        \?)
            usage $progname 1
            ;;
    esac
done


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

cd $REPONAME

# Checking directories
for i in config configuracion proyectos parciales seguimientos clases talleres
do
    createSvnDir $i
done

svn ci -m "Adding created directories to the repositories" --username $USERNAME
