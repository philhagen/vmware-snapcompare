#!/bin/sh

function CTRAP {
    trap '
        let lne++
        let lne++
        tput cup $lne $cl
        echo -n "CTRL_C Not Allowed."
        let lne++
        tput cup $lne $cl
        echo -n "Please press <ENTER> to continue."
        ' 2
    }

function PROG_BAR {
    while [ `ps ax | grep $pid | grep -v grep | awk '{ print $1 }'` ]
    do
        tput cup $lne 5
        echo -n "|"
        tput cup $lne 57
        echo -n "|"
        tput cup $lne 6
        for (( i = 1 ; i < 51 ; i++ ))
        do
            echo -n " "
            sleep $scrtime
        done
    done
    }

function GET_CURSOR {
    stty -echo
    echo -n $'\e[6n'
    read -d R x; stty echo
    lne=`echo ${x#??} | cut -f1 -d';'`
    lne=`expr $lne - 2`
}

MENUPATH=$( dirname $0 )
OUTPUTDIR=${MENUPATH}/output_files
if [ ! -e ${OUTPUTDIR} ]; then
    mkdir -p ${OUTPUTDIR}
fi
TEMP_CLEAN=/tmp/clean
TEMP_CHANGED=/tmp/changed
DATAFILE1=${OUTPUTDIR}/raw_files_path
BODYFILE_CLEAN=${OUTPUTDIR}/bodyfile_clean
BODYFILE_CHANGED=${OUTPUTDIR}/bodyfile_changed
DATAFILE_CLEAN=${OUTPUTDIR}/files_list_clean
DATAFILE_CHANGED=${OUTPUTDIR}/files_list_changed
OUTPUT_ADDED=${OUTPUTDIR}/files_added.list
OUTPUT_DELETED=${OUTPUTDIR}/files_deleted.list
OUTPUT_EDITED=${OUTPUTDIR}/files_edited.list
OUTPUT_CHANGED=${OUTPUTDIR}/files_changed.list
OUTPUT_SETID=${OUTPUTDIR}/files_setid.list
