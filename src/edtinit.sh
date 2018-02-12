#!/usr/bin/env bash

#
# created: 28/08/2017
# user: Juan Francisco Cardona Mc'Cormick (jfcmacro)
# purpose: This program initializes the $HOME/.edtcfg file and the
#          directory hierarchy.
#
# Modifications:
# (jfcmacro)
# 08/02/2018 - Adding version
# (jfcmacro)
# 24/01/2018 - Adding PATH $HOME/.local/bin
# (jfcmacro)
# 02/09/2017 - Correcting the path of env instead of /usr/ it is /usr/bin
# (jfcmacro)
# 01/09/2017 - There are maybe two differents users: USERNAME current user and
#              SVNUSERNAME user on svn repository.
#            - Correcting options: -h doesn't work. Now is correctly working
#            - Updating enviroment variable PATH adding the $HOME/bin path.
#            - On Cygwin JAVA_HOME is searching with two usual directories:
#              C:\Program Files and C:\Program Files (x86).
#            - edt_init_script.sh is correctly downloaded and executed
#              from EDT_$COURSE_URL_BASE.
#            - edt_init_script.sh is erased after it's been executed.

function getYear {
    local thisYear=$(date +"%Y")
    echo "$thisYear"
}

function getTerm {
    local thisMonth=$(date +"%m")
    local thisTerm=""
    case $thisMonth in
	0[1-6])
	    thisTerm="01"
	    ;;
	0[7-9])
	    thisTerm="02"
	    ;;
	1[0-2])
	    thisTerm="02"
	    ;;
    esac
    echo "$thisTerm"
}

function getVarMsg {
    local myvar
    echo -n $1
    myvar=read
    echo "$myvar"
}

function tolower {
    local mytolower=$(echo $1 | tr '[:upper:]' '[:lower:]')
    echo "$mytolower"
}

function toupper {
    local mytoupper=$(echo $1 | tr '[:lower:]' '[:upper:]')
    echo "$mytoupper"
}

function helpInfo {
    printf "options:\n"
    printf "\t-a: enable to add a new course to $HOME/.edtrc file\n"
    printf "\t-b <url-base>: base URL where the course is stored on internet\n"
    printf "\t-c <course>: course id name\n"
    printf "\t-g <group>: group id name\n"
    printf "\t-h: print this menu\n" 
    printf "\t-n <username>: username on the repository\n"
    printf "\t-p <prefix>: Prefix name to identify the repository. Usually it is used to compose a reponame with prefix and username\n"
    printf "\t-r <reponame>: A reponame different of that compose with prefix and username\n"
    printf "\t-u <url-versctrl>: URL where the repository exists on internet\n"
    printf "\t-v: show version\n"
    printf "\t-w versctrl: Only valid svn\n"
}

TERM=$(getTerm)
YEAR=$(getYear)
OSNAME=`uname -s`
USERNAME=`id -un`
SVNUSERNAME=$USERNAME
PREFIX="2447"
# REPOFORMAT="${PREFIX}${SVNUSERNAME}"
VERSCTRL="svn"

function createDir {
    if [ ! -d $1 ]
    then
	mkdir $1
    fi
}

function createDirGo {
    if [ ! -d $1 ]
    then
	mkdir $1
    fi
    cd $1
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
    echo "       $1 -b <url-base> -c <course> -g <group> [-n username] [-p prefix] [-r reponame] -u <url-versctrl> [-w <versctrl> ]" >&2
    echo "       $1 -a -b <url-base> -c <course> -g <group> [-n username] [-p prefix] [-r reponame] -u <url-versctrl> [-w <versctrl> ]" >&2
    echo "       $1 -v" >&2
    if [ "$2" -eq 0 ]; then
        helpInfo
    fi
    exit $2
}

function appendFile {
    echo $1 >> $2
}

function printVersion {
    printf "EafitDisTools ($1) Version: $2\n"
    exit 0
}

version=EDTPACKAGE

longprogname=$0
progname=$(basename $longprogname)

while getopts "ab:c:g:hn:p:r:u:vw:" opt; do
    case $opt in
        a)
            ADDCOURSE="add"
            ;;
	b)
	    URLBASE=$OPTARG
	    ;;
	c)
            COURSE=$(toupper $OPTARG)
            COURSELOWER=$(tolower $OPTARG)
	    ;;
	g)
	    GROUP=$OPTARG
	    ;;
	h)
	    usage $progname 0
	    ;;
        n)
            SVNUSERNAME=$OPTARG
            ;;
        p)
            PREFIX=$OPTARG
            ;;
        r)
            REPONAME=$OPTARG
            ;;
        u)
            URLVERSCTRL=$OPTARG
            ;;
        v)
            printVersion $progname $version
            ;;
	w)
	    VERSCTRL=$OPTARG
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

if [ -z "${ADDCOURSE}" -a -f $HOME/.edtrc ]; then
    echo "$HOME/.edtrc exists" >&2
    exit 1
else
    if [ -n "${ADDCOURSE}" -a ! -f $HOME/.edtrc ]; then
        echo "$HOME/.edtrc doesn't exist. To add course first, init the $HOME/.edtrc file" >&2
        exit 1
    # else
    #     if [ - -f $HOME/.edtrc ]; then
    #         echo "$HOME/.edtrc exists" >&2
    #         exit 1
    #     fi
    fi
fi

if [ -z "${URLBASE}" -o -z "${COURSE}" -o -z "${GROUP}" -o -z "${URLVERSCTRL}" ]; then
    echo "URLBASE=$URLBASE"
    echo "COURSE=$COURSE"
    echo "GROUP=$GROUP"
    echo "URLVERSCTRL=$ULRVERSCTRL"
    usage $progname 1
fi

if [ -z "${REPONAME}" ]; then
    REPONAME=$PREFIX$SVNUSERNAME
fi

cd $HOME

if [ -f .bashrc ]; then
    tmp=$(grep -c "\$HOME/bin" $HOME/.bashrc)
    if [ "${tmp}" -eq 0 ]; then
        appendFile "export PATH=\$HOME/bin:\$PATH:\$HOME/.local/bin" .bashrc
    fi
fi

# Adding JAVA_HOME variables
case $OSNAME in
    CYGWIN*)
        if [ -z "${JAVA_HOME}" ]; then
            JAVA_VERSION=$(ls /cygdrive/c/Program\ Files/Java/ | grep jdk | sed 's/jdk//g' | sort -ru | head -n 1)
            if [ -n "${JAVA_VERSION}" ]; then

	        appendFile "export JAVA_HOME=/cygdrive/c/Program\ Files/Java/jdk$JAVA_VERSION/" .bashrc
	        appendFile "export PATH=\$PATH:\$JAVA_HOME/bin" .bashrc
                #    echo "export CLASSPATH=\$(cygpath -pw .:\$CLASSPATH)">> .bashrc
	        source .bashrc
            else
                JAVA_VERSION=$(ls /cygdrive/c/Program\ Files\ \(x86\)/Java/ | grep jdk | sed 's/jdk//g' | sort -ru | head -n 1)
                if [ - "${JAVA_VERSION}" ]; then
                    appendFile "export JAVA_HOME=/cygdrive/c/Program\ Files\ \(x86\)/Java/jdk$JAVA_VERSION/" .bashrc
	            appendFile "export PATH=\$PATH:\$JAVA_HOME/bin" .bashrc
                    #    echo "export CLASSPATH=\$(cygpath -pw .:\$CLASSPATH)">> .bashrc
	            source .bashrc
                else
                    echo "You don't have Java SDK installed on the usual directories, please install one on them" >&2
                fi
            fi
        fi
        ;;
    *)
        if [ -z "${JAVA_HOME}" ]; then
            if [ -x "$(command -v javac)" ]; then
                TMP=$(command -v javac)
                TMP2=$(dirname $TMP)
                append "export JAVA_HOME=$TMP2" .bashrc
                source .bashrc
            else
                echo "You don't have Java SDK installed on the usual directories, please install one on them" >&2
            fi
        fi
        ;;
esac

# Creating directories
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

# This was move to another script
# if  [ ! -x "$(command -v ewe)" ]; then
#     if [ -x "$(command -v cabal)" ]; then
# 	echo "Installing ewe last version, it takes few minutes, please wait."
# 	cabal update
# 	cabal install ewe --prefix $(cygpath -w $HOME)
# 	source .bashrc
#     else
# 	echo "Please install Haskell Platform before install ewe" >&2
#     fi
# fi

tmp=$(grep -c "\$HOME/share/man" $HOME/.bashrc)
if [ "${tmp}" -eq 0 ]; then
    appendFile "export MANPATH=\$MANPATH:\$HOME/share/man" $HOME/.bashrc
fi

if [ -z "${ADDCOURSE}" ]; then
    cat > $HOME/.edtrc <<EOF
# Adding EDT variables for course: ${COURSE} $(date '+%Y/%m/%d-%H:%M:%S')
export EDT_CURRENT_YEAR=$YEAR
export EDT_CURRENT_TERM=$TERM
export EDT_COURSES=$COURSE
export EDT_CURRENT_COURSE=$COURSE
export EDT_${COURSE}_URL_BASE=${URLBASE}
export EDT_${COURSE}_GROUP=${GROUP}
export EDT_${COURSE}_URL_VERSION_CONTROL=${URLVERSCTRL}
export EDT_${COURSE}_USERNAME=${SVNUSERNAME}
export EDT_${COURSE}_REPONAME=${REPONAME}
export EDT_${COURSE}_PREFIX_REPO=${PREFIX}
export EDT_${COURSE}_VERSION_CONTROL=${VERSCTRL}
EOF
    appendFile ". \$HOME/.edtrc" $HOME/.bashrc
else
    tmp=$(grep -c "$COURSE" $HOME/.edtrc)
    if [ "${tmp}" -eq 0 ]; then
        sed -i "s/\(EDT_COURSES=.*$\)/\1:${COURSE}/g" $HOME/.edtrc  
        cat >> $HOME/.edtrc <<EOF 
# Adding EDT variables for course: ${COURSE} $(date '+%Y/%m/%d-%H:%M:%S')
export EDT_${COURSE}_URL_BASE=${URLBASE}
export EDT_${COURSE}_GROUP=${GROUP}
export EDT_${COURSE}_URL_VERSION_CONTROL=${URLVERSCTRL}
export EDT_${COURSE}_USERNAME=${SVNUSERNAME}
export EDT_${COURSE}_REPONAME=${REPONAME}
export EDT_${COURSE}_PREFIX_REPO=${PREFIX}
export EDT_${COURSE}_VERSION_CONTROL=${VERSCTRL}
EOF
    else
        echo "Warning: Course ${COURSE} already registed" >&2
    fi
fi

URLINITSCRIPT=$URLBASE/courses/$COURSELOWER/edt_init_script.sh

echo "Getting url $URLINITSCRIPT"

wget $URLINITSCRIPT -O edt_init_script.sh

if [ "$?" -ne 0 ]; then
    echo "edt_init_script.sh cannot be download"
    if [ -f edt_init_script.sh ]; then
        rm -f edt_init_script.sh
    fi
else
    echo "Executing edt_init_script.sh"
    bash $HOME/edt_init_script.sh
    rm -f edt_init_script.sh
fi

createDir $COURSELOWER
