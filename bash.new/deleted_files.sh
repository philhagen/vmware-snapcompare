#!/bin/bash

. $( dirname $0 )/snapcompare_common.sh

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
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "The disk partitons will be displayed"
let lne++
tput cup $lne $cl
echo -n "for selection and analysis."
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "Please press <ENTER> to continue. To EXIT press any other key."
read -n1 action
if [ -z $action ]; then
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
    echo -n "The partition are listed below:"
    lne=`expr $lne + 2`
    tput cup $lne 0
    file1=`sed -n 1p "$DATAFILE1"`
#   file2=`echo "$file1" | awk -F'/' '{ print $NF }'` # Get last segment
#   file3=`echo "$file1" | sed s/$file2//`
    /usr/local/bin/mmls "${file1}"

    GET_CURSOR

    function SECT {
        lne=`expr $lne + 2`
        tput cup $lne $cl
        echo -n "Please enter the start of the partiton sector to analyze: "
        read sector
        if [ -z $sector ]; then
            let lne++
            tput cup $lne $cl
            echo -n "Input cannot be left blank."
            let lne++
            tput cup $lne $cl
            echo -n "Do you wish to continue (y/n): "
            let lne++
            tput cup $lne $cl
            echo -n "Enter N/n to exit."
            line=`expr $lne - 1`
            tput cup $line 36
            read ans
            if [ $ans == n -o $ans == N ] &> /dev/null ; then
                exit
            else
                SECT
            fi
        else
            if [[ $sector =~ ^[0-9]+$ ]]; then
                file1=`sed -n 1p $DATAFILE1`
                file2=`sed -n 2p $DATAFILE1`
                skew=`sed -n 3p $DATAFILE1`
                /usr/local/bin/fls -m / -r -f ntfs -i raw -s $skew -o $sector "$file1" | cut -f 2 -d'|' > $DATAFILE_CLEAN &
                pid=`pgrep fls | head -1`
#               pid=`echo $!`
                let lne++
                tput cup $lne $cl
                echo -n "Content of clean snapshot are being recorded, please wait:"
                let lne++
                scrtime=1
                PROG_BAR
                /usr/local/bin/fls -m / -r -f ntfs -i raw -s $skew -o $sector "$file2" | cut -f 2 -d'|' > $DATAFILE_CHANGED &
                pid=`pgrep fls | head -1`
#               pid=`echo $!`
                lne=`expr $lne + 2`
                tput cup $lne $cl
                echo -n "Content of suspect snapshot are being recorded, please wait:"
                let lne++
                scrtime=1
                PROG_BAR
                lne=`expr $lne + 2`
                tput cup $lne $cl
                echo -n "Contents of snapshots gathered."
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
                /usr/bin/sort $DATAFILE_CLEAN > $TEMP_CLEAN &
                pid=`echo $!`
                scrtime=1
                PROG_BAR
                /usr/bin/sort $DATAFILE_CHANGED > $TEMP_CHANGED &
                pid=`echo $!`
                scrtime=1
                PROG_BAR
                /usr/bin/diff $TEMP_CLEAN $TEMP_CHANGED | grep \< | sed s/\<\ // >> $OUTPUT_DELETED &
                pid=`echo $!`
                scrtime=1
                PROG_BAR
                lne=`expr $lne + 2`
                tput cup $lne $cl
                echo -n "A list of files deleted from the VM has be"
                let lne++
                tput cup $lne $cl
                echo -n "populated and stored at: $OUTPUT_DELETED"
                let lne++
                tput cup $lne $cl
            else
                lne=`expr $lne + 2`
                tput cup $lne $cl
                echo "The input is not a number."
                let lne++
                tput cup $lne $cl
                echo -n "Do you wish to continue (y/n): "
                let lne++
                tput cup $lne $cl
                echo -n "Enter N/n to exit."
                line=`expr $lne - 1`
                tput cup $line 36
                read ans
                if [ $ans == n -o $ans == N ] &> /dev/null ; then
                    exit
                else
                    SECT
                fi
            fi
        fi
    }
    SECT
fi
