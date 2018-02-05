#!/usr/bin/env bash

#
# Created: 03/02/2018
# Programmer: Juan Francisco Cardona Mc'Cormick (jfcmacro)
# purpose: Install haskell cabal packages. This is require on
#          cygwin environment.
OSNAME=`uname -s`
longprogname=$0
progname=$(basename $longprogname)

function installCabalPackage {
    echo "Installing $1 last version, it takes few minutes, please wait."
    cabal update
    case $OSNAME in
        CYGWIN*)
	    cabal install $1 --prefix $(cygpath -w $HOME)
            ;;
        *)
            cabal install $1 --prefix $HOME
            ;;
    esac
}

function helpInfo {
    printf "options:\n"
    printf "h: show this menu\n"
    printf "v: show current version\n"
    printf "w: overwrite previous installation\n"
}

function usage {
    echo "       $1 -h" >&2
    echo "       $1 -v" >&2
    echo "       $1 [-w] <cabal-package-to-install>" >&2
    if [ "$2" -eq 0 ]; then
        helpInfo
    fi
    exit $2
}

while getopts "hvw" opt; do
    case $opt in
        h)
            usage $progname 0
            ;;
        v)
            printf "EafitDisTools ($progname) Version: 0.0.1.19\n"
            exit 0
            ;;
        w)
            OWINST="owinst"
            shift
            ;;
        \?)
            usage $progname 1
            ;;
    esac
done

if [ ! -x "$(command -v cabal)" ]; then
    echo "Please install Haskell Platform before install $1" >&2
    exit 1
fi

if  [ ! -x "$(command -v $1)" ]; then
    installCabalPackage $1
else
    if [ ! -z "${OWINST}" ]; then
        installCabalPackage $1
    fi
fi
