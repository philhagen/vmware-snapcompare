#!/bin/bash

. $( dirname $0 )/snapcompare_common.sh
if [ -e ${OUTPUT_CHANGED} ]; then
    echo "ERROR: ${OUTPUT_CHANGED} already exists - returning to menu to prevent accidental overwrite!"
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
echo -n "View Files Changed [Change Time]"
tput rmso

function SECT {
    file1=`sed -n 1p $DATAFILE1`
    file2=`sed -n 2p $DATAFILE1`
    skew=`sed -n 3p $DATAFILE1`
    sector=`sed -n 4p $DATAFILE1`
    /usr/local/bin/fls -m / -r -f ntfs -i raw -s $skew -o $sector "$file1" | cut -f 2,10 -d'|' > $DATAFILE_CLEAN &
    pid=`pgrep fls | head -1`
    let lne++
    tput cup $lne $cl
    echo -n "Content of clean snapshot are being recorded, please wait:"
    let lne++
    scrtime=1
    PROG_BAR
    /usr/local/bin/fls -m / -r -f ntfs -i raw -s $skew -o $sector "$file2" | cut -f 2,10 -d'|' > $DATAFILE_CHANGED &
    pid=`pgrep fls | head -1`
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
    echo -n "View Files Changed [Change Time]"
    tput rmso
    lne=`expr $lne + 2`
    tput cup $lne $cl
    echo -n "Analysing files, please wait.."
    lne=`expr $lne + 2`
    tput cup $lne $cl
    echo -n "This is a very time intensive process and might take"
    let lne++
    tput cup $lne $cl
    echo -n "a several hours, please leave the program running."
    let lne++
    tput cup $lne $cl
    echo -n "No progress bar will be displayed."
    echo "" > $OUTPUT_CHANGED
    echo "" >> $OUTPUT_CHANGED
    echo " Following are the files that have been changed:" >> $OUTPUT_CHANGED
    echo "" >> $OUTPUT_CHANGED
    echo "" >> $OUTPUT_CHANGED
    /usr/bin/sort $DATAFILE_CLEAN > $TEMP_CLEAN
    /usr/bin/sort $DATAFILE_CHANGED > $TEMP_CHANGED
    num_lines=`wc -l $TEMP_CLEAN | awk '{ print $1 }'`
    for (( i = 1 ; i <= $num_lines ; i++ ))
    do
        line_file=`sed -n ${i}p $TEMP_CLEAN | sed 's/\[/\\\[/'`
        c_time_clean=`echo ${line_file##*|}`
        if [ $c_time_clean -ne 0 ] ; then
            grep_word=`echo $line_file | sed s/$c_time_clean//`
            result=`grep "^$grep_word" $TEMP_CHANGED`
            if [ -z $result ] &> /dev/null ; then
                :
            else
                c_time_changed=`echo ${result##*|}`
                if [ $c_time_changed -ne 0 ] ; then
                    if [ $c_time_changed -ne $c_time_clean ] ; then
                        echo -e "Original Change Time\t`date --date="1970-01-01 00:00:00 UTC +${c_time_clean} seconds" +%c`\nFile name\t\t${line_file%|*}\nCurrent Change Time\t`date --date="1970-01-01 00:00:00 UTC +${c_time_changed} seconds" +%c`\n" >> $OUTPUT_CHANGED
                    fi
                fi
            fi
        fi
    done
    lne=`expr $lne + 2`
    tput cup $lne $cl
    echo -n "A list of files changed in the VM has be"
    let lne++
    tput cup $lne $cl
    echo -n "populated and stored at: $OUTPUT_CHANGED"
    let lne++
    tput cup $lne $cl
}
SECT
