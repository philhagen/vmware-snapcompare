#!/bin/bash

. $( dirname $0 )/snapcompare_common.sh

DATAFILE_CLEAN=${DATAFILE_CLEAN}_SETID
DATAFILE_CHANGED=${DATAFILE_CHANGED}_SETID

if [ -e ${OUTPUT_SETID} ]; then
    echo "ERROR: ${OUTPUT_SETID} already exists - returning to menu to prevent accidental overwrite!"
    read
    exit
fi

lne=5
cl=5
CTRAP
tput clear
tput smso
tput cup $lne $cl
echo -n "VM SNAPSHOT ANALYSIS"
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "View Files with Recent SETUID/SETGID Changes"
tput rmso

function SECT {
    file1=`sed -n 1p $DATAFILE1`
    file2=`sed -n 2p $DATAFILE1`
    skew=`sed -n 3p $DATAFILE1`
    sector=`sed -n 4p $DATAFILE1`
    cat $BODYFILE_CLEAN | cut -f 2,4 -d'|' | grep -iE "\|...r.s|\|......r.s" > $DATAFILE_CLEAN
    cat $BODYFILE_CHANGED | cut -f 2,4 -d'|' | grep -iE "\|...r.s|\|......r.s" > $DATAFILE_CHANGED
    lne=`expr $lne + 2`
    tput cup $lne $cl
    tput clear
    lne=5
    cl=5
    tput clear
    tput smso
    tput cup $lne $cl
    echo -n "VM SNAPSHOT ANALYSIS"
    lne=`expr $lne + 2`
    tput cup $lne $cl
    echo -n "View Files with Recent SETUID/SETGID Changes"
    tput rmso
    lne=`expr $lne + 2`
    tput cup $lne $cl
    echo -n "Analysing files, please wait.."
    echo "" > $OUTPUT_SETID
    echo "" >> $OUTPUT_SETID
    echo " Following are the files with SETUID/SETGID changes." >> $OUTPUT_SETID
    echo "" >> $OUTPUT_SETID
    echo "" >> $OUTPUT_SETID
    lne=`expr $lne + 2`
    tput cup $lne $cl
    /usr/bin/sort $DATAFILE_CLEAN > $TEMP_CLEAN &
    pid=`echo $!`
    scrtime=1
    PROG_BAR
    /usr/bin/sort $DATAFILE_CHANGED > $TEMP_CHANGED &
    pid=`echo $!`
    scrtime=1
    PROG_BAR
    /usr/bin/diff $TEMP_CLEAN $TEMP_CHANGED | grep \> | sed s/\>\ // >> $OUTPUT_SETID &
    pid=`echo $!`
    scrtime=1
    PROG_BAR
    lne=`expr $lne + 2`
    tput cup $lne $cl
    echo -n "A list of files with SETUID/SETGID changes are"
    let lne++
    tput cup $lne $cl
    echo -n "populated and stored at: $OUTPUT_SETID"
    let lne++
    tput cup $lne $cl
}
SECT
