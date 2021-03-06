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
echo -n "Select Snapshots to Compare"
tput rmso
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "Note 1: Please input path of RAW files only."
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "Note 2: Please input complete file path."
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "Note 3: Please make sure the snapshots belong to the same VM."

function PATH_1 {
    lne=`expr $lne + 2`
    tput cup $lne $cl
    echo -n "Please input path of clean snapshot which "
    let lne++
    tput cup $lne $cl
    echo -n "will be used as a basline for comparison."
    let lne++
    tput cup $lne $cl
    echo -n "PATH 1: "
    read path1
    if [ -z "$path1" ]; then
        let lne++
        tput cup $lne $cl
        echo -n "Path cannot be left empty."
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
            PATH_1
        fi
    else
        if [ -f "$path1" ]; then
            echo "$path1" > $DATAFILE1
        else
            let lne++
            tput cup $lne $cl
            echo -n "File does not exist or path incorrect."
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
                PATH_1
            fi
        fi
    fi
}
PATH_1

function PATH_2 {
    lne=`expr $lne + 2`
    tput cup $lne $cl
    echo -n "Please input path of suspected snapshot which"
    let lne++
    tput cup $lne $cl
    echo -n "will be against the basline for comparison."
    let lne++
    tput cup $lne $cl
    echo -n "PATH 2: "
    read path2
    if [ -z "$path2" ]; then
        let lne++
        tput cup $lne $cl
        echo -n "Path cannot be left empty."
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
            PATH_2
        fi
    else
        if [ -f "$path2" ]; then
            echo "$path2" >> $DATAFILE1

        else
            let lne++
                tput cup $lne $cl
            echo -n "File does not exist or path incorrect."
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
                PATH_2
            fi
        fi
    fi
}
PATH_2

function SKEW {
    lne=`expr $lne + 2`
    tput cup $lne $cl
    echo -n "Please input the time skew of the system in seconds, else enter 0:"
    read skew
    if [ -z $skew ]; then
        let lne++
        tput cup $lne $cl
        echo -n "Skew cannot be left empty."
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
            SKEW
        fi
    else
        skew1=`echo $skew | sed 's/-//'`
        if [[ "$skew1" =~ ^[0-9]+$ ]]; then
            echo $skew >> $DATAFILE1
            lne=`expr $lne + 2`
            tput cup $lne $cl
            echo -n "Both files seem to be valid, paths recorded."
        else
            let lne++
            tput cup $lne $cl
            echo -n "Input is not a number."
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
                SKEW
            fi
        fi
    fi
}
SKEW

lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "The disk partitions are displayed below"
let lne++
tput cup $lne $cl
echo -n "Input offset for partition to analyze."

/usr/local/bin/mmls "${path1}"

GET_CURSOR

function OFFSET {
    lne=`expr $lne + 2`
    tput cup $lne $cl
    echo -n "Please enter the start of the partition sector to analyze:"
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
        if [ $ans == n -o $ans == N ]; &> /dev/null ; then
            exit
        else
            OFFSET
        fi
    else
        if [[ "$sector" =~ ^[0-9]+$ ]]; then
            echo $sector >> $DATAFILE1
            lne=`expr $lne + 2`
            tput cup $lne $cl
            echo -n "Sector seems valid and was recorded."
            let lne++
            tput cup $lne $cl
        else
            let lne++
            tput cup $lne $cl
            echo -n "Input is not a number."
            let lne++
            tput cup $lne $cl
            echo -n "Do you wish to continue (y/n): "
            let lne++
            tput cup $lne $cl
            echo -n "Enter N/n to exit."
            line=`expr $lne - 1`
            tput cup $lne 36
            read ans
            if [ $ans == n -o $ans == N ] &> /dev/null ; then
                exit
            else
                OFFSET
            fi
        fi
    fi
}
OFFSET

file1=`sed -n 1p $DATAFILE1`
file2=`sed -n 2p $DATAFILE1`
skew=`sed -n 3p $DATAFILE1`
sector=`sed -n 4p $DATAFILE1`

echo -n "Content of clean snapshot are being recorded, please wait:"
/usr/local/bin/fls -m / -r -f ntfs -i raw -s $skew -o $sector "$file1" > $BODYFILE_CLEAN
let lne++
tput cup $lne $cl
echo -n "Content of suspect snapshot are being recorded, please wait:"
/usr/local/bin/fls -m / -r -f ntfs -i raw -s $skew -o $sector "$file2" > $BODYFILE_CHANGED
lne=`expr $lne + 2`
tput cup $lne $cl
