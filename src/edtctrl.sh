#!/bin/bash

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
}

function usage {
    printf "\t -h\n" >&2
    printf "\t-r <variables summary>\n"
    printf "\t-c <change course>\n "
    printf "\t-i <interactive view of courses>\n" >&2

    exit $2
}


changeVar() {
    tmp=$(grep -c "EDT_CURRENT_COURSE" $HOME/.edtrc)

    if [ "${tmp}" > 0 ]; then
	aux='EDT_CURRENT_COURSE='
	sed -i '' "/${aux}.*/s/$EDT_CURR_COURSE/${aux}${COURSE}/g" $HOME/.edtrc
	        
    fi
    source $HOME/.edtrc
}

if [ ! -f $HOME/.edtrc ]; then
    echo "$HOME/.edtrc doesn´t exist, please execute edtinit" 2>&1
    exit 1

else
    source $HOME/.edtrc
fi

USERNAME='id -un'
COURSE="$EDT_CURRENT_COURSE"
tmp="EDT_${COURSE}_REPONAME"
eval REPONAME='$'$tmp
tmp="EDT_${COURSE}_USERNAME"
eval USERNAME='$'$tmp

longprogname=$0
progname=$(basename $longprogname)
while getopts "hrc:i" opt; do
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
	    courses='ST0244 ST0270'
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
	
	\?)
	    usage $progname 0
	    ;;
	:)
	    echo "Option -$OPTARG requieres an argument." >&2
	    exit 1
	    ;;
    esac
done 
