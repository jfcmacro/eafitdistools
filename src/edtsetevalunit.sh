#!/bin/env bash

#
# created: 30/08/2017
# user: Juan Francisco Cardona Mc'Cormick (jfcmacro)
# purpose: This program set the current eval unit
#
# Modifications:
# 30/08/2017 - Updating 
# 26/08/2017 - Generalizing the script in order to manage diferents OS.
#

function tolower {
    local mytolower=$(echo $1 | tr '[:upper:]' '[:lower:]')
    echo "$mytolower"
}

function createSvnDirGo {
    if [ ! -d $1 ]
    then
	svn mkdir $1 && cd $1
    else
	cd $1
    fi
}

function usage {
    echo "       $1 -h" >&2
    echo "       $1 [-c|-p|-t] -n <number>" >&2
    echo "       $1 [-y] -n <proyect-name> [-w]" >&2
    exit $2
}

EVALUNIT="clases"
EVALNAME="clase"

longprogname=$0
progname=$(basename $longprogname)

while getopts "chn:ptwy" opt; do
    case $opt in
	c)
            EVALUNIT="clases"
            EVALNAME="clase"
	    ;;
        h)
	    usage $progname 0
	    ;;
	p)
	    EVALUNIT="parciales"
            EVALNAME="parcial"
	    ;;
	t)
	    EVALUNIT="talleres"
            EVALNAME="taller"
	    ;;
        n)
            NUMBER=$OPTARG
            ;;
        w)
            WRITE="true"
            ;;
        y)
            EVALUNIT="proyectos"
            EVALNAME=""
            ;;
	\?)
	    usage $progname 1
	    ;;
	:)
	    echo "Option -$OPTARG requires an argument." >&2
	    exit 1
	    ;;
    esac
done

if [ ! -f $HOME/.edtrc ]; then
    echo "$HOME/.edtrc doesn't exists, please execute edtinit" 2>&1
    exit 1
else
    source $HOME/.edtrc
fi

if [ -z "${NUMBER}" ]; then
    usage $progname 1
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

cd $HOME/$COURSELOWER

if [ ! -d "${REPONAME}" ]
then
    echo "You don't have a work area on you computer, please execute edtgetrepos"
    exit 1
fi

cd $REPONAME

svn up --username $USERNAME

createSvnDirGo $EVALUNIT

case $EVALUNIT in
    clases|parciales|talleres)
        createSvnDirGo $EVALNAME$NUMBER
        ;;
    proyectos)
        EVALNAME=$NUMBER
        if [ -z $WRITE ]; then
            if [ ! -d $EVALNAME ]; then
                echo "Eval unit $EVALNAME must be write, please use -w option" >&2
                exit 1
            fi
        else
            if [ -d $EVALNAME ]; then
                    echo "Eval unit $EVALNAME is already created" >&2
            else
                svn mkdir $EVALNAME 
            fi
        fi
        cd $EVALNAME
        ;;
esac

exec bash
