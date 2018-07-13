#!/usr/bin/env bash

#
# created: 11/08/2017
# user: Juan Francisco Cardona Mc'Cormick (jfcmacro)
# purpose: This program create a directory hierarchy
#
# Modifications:
# (jfcmacro)
# 13/07/2018 - Taking in count Subversion good practices (trunk,branch,tag) 
# (jfcmacro)
# 20/06/2018 - Adding new option c to avoid unnecessary directories created
# (jfcmacro)
# 08/02/2018 - Adding version
# (jfcmacro)
# 24/01/2018 - Adding PATH $HOME/.local/bin
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
    printf "\t-r: set the repository name and shows a summary of variable values\n"
    printf "\t-n: set the username\n"
    printf "\t-u: set the version control\n"
    printf "\t-c: create a serie of directories and add to the repository\n"
}

function usage {
    printf "\t$1 -h\n" >&2
    printf "\t$1 [-r]\n" >&2
    printf "\t$1 [-n]\n" >&2
    printf "\t$1 [-u]\n" >&2
    printf "\t$1 [-c]\n" >&2
    
    if [ "$2" -eq 0 ]; then
        helpInfo
    fi
    exit $2
}

function printVersion {
    printf "EafitDisTools ($1) Version: $2\n"
    exit 0
}

version=EDTPACKAGE

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
eval COURSE_REPONAME='$'$tmp
tmp="EDT_${COURSE}_USERNAME"
eval USERNAME='$'$tmp
tmp="EDT_${COURSE}_URL_BASE"
eval URLBASE='$'$tmp
tmp="EDT_${COURSE}_URL_VERSION_CONTROL"
eval URLVERSIONCONTROL='$'$tmp

longprogname=$0
progname=$(basename $longprogname)
createdirs=false

while getopts "hcr:u:n:v" opt; do
    case $opt in
        h)
            usage $progname 0
            ;;
	c)
	    createdirs=true
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
        v)
            printVersion $progname $version
            ;;
	\?)
	    usage $progname 1
	    ;;
    esac
done

cd $HOME/$COURSELOWER

if [ -d "${REPONAME}" ]
then
    cd $REPONAME
    svn up --username $USERNAME
else
    if [ -n "${REPONAME}" ]
    then
        if [[ $REPONAME =~ (.tag.|.branch.) ]]
        then
            svn co $URLVERSIONCONTROL/$REPONAME --username $USERNAME
        else
            if [[ $REPONAME =~ .trunk. ]]
            then
                svn co $URLVERSIONCONTROL/$REPONAME --username $USERNAME
            else
                svn info $URLVERSIONCONTROL/$REPONAME/trunk --username $USERNAME 2>&1 1>/dev/null
                if [ "$?" -eq 0 ]
                then
                    svn co $URLVERSIONCONTROL/$REPONAME/trunk $REPONAME --username $USERNAME
                else
                    svn co $URLVERSIONCONTROL/$REPONAME --username $USERNAME
                fi
            fi 
        fi
    fi
fi

if [ "$?" -ne 0 ]
then
    echo "You don't have a repository, please add one"
    exit 1
fi


# Checking directories
if [ "$REPONAME" == "$COURSE_REPONAME" ]
then
    cd $REPONAME

    if [ "$createdirs" = true ]; then
	
	for i in configuracion proyectos parciales seguimientos clases talleres
	do
            createSvnDir $i
	done

        svn ci -m "Adding created directories to the repositories" --username $USERNAME
    fi
fi
