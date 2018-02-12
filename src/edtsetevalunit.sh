#!/usr/bin/env bash

#
# created: 30/08/2017
# user: Juan Francisco Cardona Mc'Cormick (jfcmacro)
# purpose: This program set the current eval unit
#
# Modifications:
# (jfcmacro)
# 08/02/2018 - Adding version
# (jfcmacro)
# 02/09/2017 - Correcting the path of env instead of /usr/ was /usr/bin
# (jfcmacro)
# 30/08/2017 - Updating
# (jfcmacro)
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

function helpInfo {
    printf "options:\n" >&2
    printf "\t-h: prints the help\n" >&2
    printf "\t-c: select 'Clases' eval unit\n" >&2
    printf "\t-p: select 'Parciales' eval unit\n" >&2
    printf "\t-t: select 'Talleres' eval unit\n" >&2
    printf "\t-v: print version\n" >&2
    printf "\t-y: select 'proYectos' eval unit\n" >&2
    printf "\t-n: <number> of eval unit\n" >&2
    printf "\t-n: <proyect-name>\n" >&2
    printf "\t-w: write 'proYectos' unit into disk\n" >&2
}

function usage {
    printf "\t$1 -h\n" >&2
    printf "\t$1 [-c|-p|-t] -n <number>\n" >&2
    printf "\t$1 -y -n <project-name> [-w]\n" >&2
    if [ "$2" -eq 0 ]; then
        helpInfo
    fi
    exit $2
}

function printVersion {
    printf "EafitDisTools ($1) Version: $2\n"
    exit 0
}

EVALUNIT="clases"
EVALNAME="clase"

longprogname=$0
progname=$(basename $longprogname)
version=EDTPACKAGE

while getopts "chn:ptwyv" opt; do
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
        v)
            printVersion $progname $version
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
