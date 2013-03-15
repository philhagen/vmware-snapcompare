#!/bin/bash

. $( dirname $0 )/snapcompare_common.sh

lne=5
cl=5
CTRAP
tput clear
tput smso
tput cup $lne $cl
echo -n "VM SNAPSHOT ANALYSIS"
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "View Select Snapshots"
tput rmso
if [ -f $DATAFILE1 ]; then
    file1=`sed -n 1p "$DATAFILE1"`
    file2=`sed -n 2p "$DATAFILE1"`
    skew=`sed -n 3p "$DATAFILE1"`
    sector=`sed -n 4p "$DATAFILE1"`
    if [ ! -z "$file1" ]&&[ ! -z "$file2" ]; then
        lne=`expr $lne + 2`
        tput cup $lne $cl
        echo -n "Baseline snapshot: $file1"
        lne=`expr $lne + 2`
        tput cup $lne $cl
        echo -n "Suspected snapshot: $file2"
        lne=`expr $lne + 2`
        tput cup $lne $cl
        echo -n "Time Skew: $skew seconds"
        lne=`expr $lne + 2`
        tput cup $lne $cl
        echo -n "Sector offset: $sector"
    else
        NO_FILE
    fi
else
    NO_FILE
fi
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "Please press <ENTER> to continue."
read
