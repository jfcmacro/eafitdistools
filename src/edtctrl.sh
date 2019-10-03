#!/usr/bin/env bash

#
# created: 02/10/2017
# user: Natalias Arias (narias16)
# purpose: Show the current configuration file (.edtrc) and change it
#          with the new user information
#
# Modifications:
# (jfcmacro)
# 24/07/2018 - Show more courses and options
# (jfcmacro)
# 11/03/2017 - Instead of using sed -i, it was replaced with sed .. > tmpfile
# (jfcmacro)
# 12/02/2017 - Adding version, change #! in order to be more generic

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

function tolower {
    local mytolower=$(echo $1 | tr '[:upper:]' '[:lower:]')
    echo "$mytolower"
}

function helpInfo {
    printf "options:\n" >&2
    printf "\t-h: prints the help\n"
    printf "\t-r: shows a summary of variable values\n"
    printf "\t-c: changes the current course to the value given\n"
    printf "\t-i: shows all the courses available\n"
    printf "\t-v: shows current version\n"
    printf "\t-y: update current year and term\n"
}

function usage {
    printf "\t -h\n" >&2
    printf "\t-r <variables summary>\n"
    printf "\t-c <change course>\n "
    printf "\t-i <interactive view of courses>\n" >&2
    printf "\t-y\n" >&2
    exit $2
}

changeVar() {
    tmp=$(grep -c "EDT_CURRENT_COURSE" $HOME/.edtrc)

    if [ "${tmp}" > 0 ]; then
	aux='EDT_CURRENT_COURSE='
	# sed -i "/${aux}.*/s/$EDT_CURR_COURSE/${aux}${COURSE}/g" $HOME/.edtrc
        tmpfile=$(mktemp /tmp/edtrc.XXXXXX)
        sed "/${aux}.*/s/$EDT_CURR_COURSE/${aux}${COURSE}/g" $HOME/.edtrc > $tmpfile
        cp $tmpfile $HOME/.edtrc
        rm $tmpfile
    fi
    source $HOME/.edtrc
}

changeYearVar() {
    tmp=$(grep -c "EDT_CURRENT_YEAR" $HOME/.edtrc)

    if [ "${tmp}" > 0 ]; then
	aux='EDT_CURRENT_YEAR='
	# sed -i "/${aux}.*/s/$EDT_CURR_COURSE/${aux}${COURSE}/g" $HOME/.edtrc
        tmpfile=$(mktemp /tmp/edtrc.XXXXXX)
        sed "/${aux}.*/s/$EDT_CURR_YEAR/${aux}${YEAR}/g" $HOME/.edtrc > $tmpfile
        cp $tmpfile $HOME/.edtrc
        rm $tmpfile

    fi
    source $HOME/.edtrc
}

changeTermVar() {
    tmp=$(grep -c "EDT_CURRENT_YEAR" $HOME/.edtrc)

    if [ "${tmp}" > 0 ]; then
	aux='EDT_CURRENT_TERM='
	# sed -i "/${aux}.*/s/$EDT_CURR_COURSE/${aux}${COURSE}/g" $HOME/.edtrc
        tmpfile=$(mktemp /tmp/edtrc.XXXXXX)
        sed "/${aux}.*/s/$EDT_CURR_TERM/${aux}${TERM}/g" $HOME/.edtrc > $tmpfile
        cp $tmpfile $HOME/.edtrc
        rm $tmpfile
    fi
    source $HOME/.edtrc
}

function printVersion {
    printf "EafitDisTools ($1) Version: $2\n"
    exit 0
}

if [ ! -f $HOME/.edtrc ]; then
    echo "$HOME/.edtrc doesn´t exist, please execute edtinit" 2>&1
    exit 1

else
    source $HOME/.edtrc
fi

USERNAME='id -un'
COURSE="$EDT_CURRENT_COURSE"
TERM=$(getTerm)
YEAR=$(getYear)
tmp="EDT_${COURSE}_REPONAME"
eval REPONAME='$'$tmp
tmp="EDT_${COURSE}_USERNAME"
eval USERNAME='$'$tmp

longprogname=$0
progname=$(basename $longprogname)

version=EDTPACKAGE

while getopts "hrc:ivy" opt; do
    case $opt in

	h)
	    helpInfo $progname 0
	    ;;
	r)
	    echo "course: $COURSE"
	    echo "username: $USERNAME"
            echo "reponame: $REPONAME"
	    ;;
	c)
	    COURSE=$OPTARG
	    COURSELOWER=$(tolower $OPTARG)
	    changeVar
	    ;;
	i)
	    courses=${EDT_COURSES//:/ }
	    PS3='Select Course: '
	    select course in $courses
	    do
		if [ !"$course" ]
		then
		    COURSE=$course
		    break
		fi

	    done
	    changeVar
	    ;;
        y)
            YEAR=$(getYear)
            TERM=$(getTerm)
            changeYearVar
            changeTermVar
            ;;
        v)
	    printVersion $progname $version
            ;;
	\?)
	    usage $progname 0
	    ;;
	:)
	    echo "Option -$OPTARG requieres an argument." >&2
	    exit 1
	    ;;
    esac
done
