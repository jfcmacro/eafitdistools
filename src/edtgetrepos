#!/bin/env bash

#
# created: 11/08/2017
# user: Juan Francisco Cardona Mc'Cormick (jfcmacro)
# purpose: This program create a directory hierarchy
#
# Modifications:
# 26/08/2017 - Generalizing the script in order to manage diferents OS.
#

function tolower {
    local mytolower=$(echo $1 | tr '[:upper:]' '[:lower:]')
    echo "$mytolower"
}

OSNAME=`uname -s`
USERNAME=`id -un`
PREFIX="2447"
REPO="$PREFIX$USERNAME"
SUBJECT="ST0244"
SUBLOWER=$(tolower $SUBJECT)

function createDir {
    if [ ! -d $1 ]
    then
	mkdir $1
    fi
}

function createSvnDirGo {
    if [ ! -d $1 ]
    then
	svn mkdir $1 && cd $1
    else
	cd $1
    fi
}

function linkDir {
    ALTHOME=/cygdrive/c/Users
    if [ -d $HOME/$1 ]
    then
	if  [ ! -h $HOME/$2 ]; then
	    ln -s $HOME/$1  $HOME/$2 2>/dev/null
	fi
    else
	if [ -d $ALTHOME/$3/$1 ]; then
            if [ ! -h $HOME/$2 ]; then
                ln -s $ALTHOME/$3/$1  $HOME/$2 2>/dev/null
            fi
	fi
    fi
}

function usage {
    echo "       $1 -h" >&2
    echo "       $1 [-r <repo>] [-u <username>] [-p <prefix-repo>] [-s <subject>]" >&2
    exit $2
}

function appendFile {
    echo $1 >> $2
}

progname=$0

while getopts ":r:u:p:hs:" opt; do
    case $opt in
	r)
	    REPO=$OPTARG
	    ;;
	u)
	    USERNAME=$OPTARG
	    ;;
	p)
	    PREFIX=$OPTARG
	    ;;
	h)
	    usage $progname 0
	    ;;
	s)
	    SUBJECT=$OPTARG
	    SUBLOWER=$(tolower $SUBJECT)
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

# exit 0

cd $HOME

case $OSNAME in
    CYGWIN*)
        if [ -z "${JAVA_HOME}" ]; then
            JAVA_VERSION=$(ls /cygdrive/c/Program\ Files/Java/ | grep jdk | sed 's/jdk//g' | sort -ru | head -n 1)
            if [ -n "${JAVA_VERSION}" ]; then

	        appendFile "export JAVA_HOME=/cygdrive/c/Program\ Files/Java/jdk$JAVA_VERSION/" .bashrc
	        appendFile "export PATH=\$PATH:\$JAVA_HOME/bin" .bashrc
                #    echo "export CLASSPATH=\$(cygpath -pw .:\$CLASSPATH)">> .bashrc
	        source .bashrc
            fi
        fi
        ;;
    *)
        ;;
esac

for i in bin lib share include tmp
do
    createDir $i
done

case $OSNAME in
    CYGWIN*)
        linkDir AppData appdata $USERNAME
        linkDir Documents docs $USERNAME
        linkDir Desktop escritorio $USERNAME
        linkDir Downloads descargas $USERNAME
        ;;
    *)
        ;;
esac
cd $HOME

if  [ ! -x "$(command -v ewe)" ]; then
    if [ -x "$(command -v cabal)" ]; then
	echo "Installing ewe last version, it takes few minutes, please wait."
	cabal update
	cabal install ewe --prefix $(cygpath -w $HOME)
	appendFile "export PATH=\$HOME/bin:\$PATH" .bashrc
	source .bashrc
    else
	echo "Please install Haskell Platform before install ewe" >&2
    fi
fi

createDir $SUBLOWER

cd $HOME/$SUBLOWER

if [ -z "${REPO}" ]
then
    svn co https://svn.riouxsvn.com/$PREFIX$USERNAME --username $USERNAME
else
    svn co https://svn.riouxsvn.com/$REPO --username $USERNAME
fi

if [ "$?" -ne 0 ]
then
    echo "You don't have a repository, please add one"
    exit 1
fi
