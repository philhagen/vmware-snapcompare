#!/bin/bash

. $( dirname $0 )/snapcompare_common.sh

DATAFILE_CLEAN=${DATAFILE_CLEAN}_DELETE
DATAFILE_CHANGED=${DATAFILE_CHANGED}_DELETE

if [ -e ${OUTPUT_DELETED} ]; then
    echo "ERROR: ${OUTPUT_DELETED} already exists - returning to menu to prevent accidental overwrite!"
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
echo -n "View Files Deleted"
tput rmso

function SECT {
    file1=`sed -n 1p $DATAFILE1`
    file2=`sed -n 2p $DATAFILE1`
    skew=`sed -n 3p $DATAFILE1`
    sector=`sed -n 4p $DATAFILE1`
    cat $BODYFILE_CLEAN | cut -f 2 -d'|' > $DATAFILE_CLEAN
    cat $BODYFILE_CHANGED | cut -f 2 -d'|' > $DATAFILE_CHANGED
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
    echo -n "View Files Deleted"
    tput rmso
    lne=`expr $lne + 2`
    tput cup $lne $cl
    echo -n "Analysing files, please wait.."
    echo "" > $OUTPUT_DELETED
    echo "" >> $OUTPUT_DELETED
    echo " Following are the files that have been deleted:" >> $OUTPUT_DELETED
    echo "" >> $OUTPUT_DELETED
    echo "" >> $OUTPUT_DELETED
    lne=`expr $lne + 2`
    tput cup $lne $cl
    /usr/bin/sort $DATAFILE_CLEAN > $TEMP_CLEAN
    /usr/bin/sort $DATAFILE_CHANGED > $TEMP_CHANGED
    /usr/bin/diff $TEMP_CLEAN $TEMP_CHANGED | grep \< | sed s/\<\ // >> $OUTPUT_DELETED
    lne=`expr $lne + 2`
    tput cup $lne $cl
    echo -n "A list of files deleted from the VM has be"
    let lne++
    tput cup $lne $cl
    echo -n "populated and stored at: $OUTPUT_DELETED"
    let lne++
    tput cup $lne $cl

    rm -f $TEMP_CLEAN
    rm -f $TEMP_CHANGED
    rm -f $DATAFILE_CLEAN
    rm -f $DATAFILE_CHANGED
}
SECT
