#!/bin/bash

. $( dirname $0 )/snapcompare_common.sh
if [ -e ${OUTPUT_EDITED} ]; then
    echo "ERROR: ${OUTPUT_EDITED} already exists - returning to menu to prevent accidental overwrite!"
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
echo -n "View Files Edited [Modification Time]"
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
    echo -n "View Files Edited [Modification Time]"
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
                /usr/local/bin/fls -m / -r -f ntfs -i raw -s $skew -o $sector "$file1" | cut -f 2,9 -d'|' > $DATAFILE_CLEAN &
                pid=`pgrep fls | head -1`
#               pid=`echo $!`
                let lne++
                tput cup $lne $cl
                echo -n "Content of clean snapshot are being recorded, please wait:"
                let lne++
                scrtime=1
                PROG_BAR
                /usr/local/bin/fls -m / -r -f ntfs -i raw -s $skew -o $sector "$file2" | cut -f 2,9 -d'|' > $DATAFILE_CHANGED &
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
                echo -n "View Files Edited [Modification Time]"
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
                echo "" > $OUTPUT_EDITED
                echo "" >> $OUTPUT_EDITED
                echo " Following are the files that have been edited:" >> $OUTPUT_EDITED
                echo "" >> $OUTPUT_EDITED
                echo "" >> $OUTPUT_EDITED
                /usr/bin/sort $DATAFILE_CLEAN > $TEMP_CLEAN
                /usr/bin/sort $DATAFILE_CHANGED > $TEMP_CHANGED
#               cat /dev/null > $OUTPUT_EDITED
                num_lines=`wc -l $TEMP_CLEAN | awk '{ print $1 }'`
                for (( i = 1 ; i <= $num_lines ; i++ ))
                do
                    line_file=`sed -n ${i}p $TEMP_CLEAN | sed 's/\[/\\\[/'`
                    m_time_clean=`echo ${line_file##*|}`
                    if [ $m_time_clean -ne 0 ] ; then
                        grep_word=`echo $line_file | sed s/$m_time_clean//`
                        result=`grep "^$grep_word" $TEMP_CHANGED`
                        if [ -z $result ] &> /dev/null ; then
                            :
                        else
                            m_time_changed=`echo ${result##*|}`
                            if [ $m_time_changed -ne 0 ] ; then
                                if [ $m_time_changed -ne $m_time_clean ] ; then
#                                   echo "`date --date="1970-01-01 00:00:00 UTC +${m_time_clean} seconds" +%c` ${line_file%|*} `date --date="1970-01-01 00:00:00 UTC +${m_time_changed} seconds" +%c`" >> $OUTPUT_EDITED
                                    echo -e "Original Modification Time\t`date --date="1970-01-01 00:00:00 UTC +${m_time_clean} seconds" +%c`\nFile name\t\t\t${line_file%|*}\nCurrent Modification Time\t`date --date="1970-01-01 00:00:00 UTC +${m_time_changed} seconds" +%c`\n" >> $OUTPUT_EDITED
                                fi
                            fi
                        fi
                    fi
                done
                lne=`expr $lne + 2`
                tput cup $lne $cl
                echo -n "A list of files editied in the VM has be"
                let lne++
                tput cup $lne $cl
                echo -n "populated and stored at: $OUTPUT_EDITED"
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
