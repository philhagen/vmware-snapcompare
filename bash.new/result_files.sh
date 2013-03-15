#!/bin/bash

. $( dirname $0 )/snapcompare_common.sh

choice=1
until [ $choice == 0 ]
do
lne=5
cl=5
tput clear
tput smso
tput cup $lne $cl
echo -n "VM SNAPSHOT ANALYSIS"
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "View Analysis Result Files"
tput rmso
let lne++
i=0
for files in `ls $OUTPUTDIR`
    do
    let lne++
    let i++
    no_file[$i]=$files
    tput cup $lne $cl
    echo -n "${i}) $files"
done
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "0) EXIT"
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "Please enter choice to view file [1-${i},0]: "
CTRAP; read choice
case $choice in
    [1-$i])
        no_line=`wc -l $OUTPUTDIR/${no_file[$choice]} | awk '{ print $1 }'`
        if [ $no_line -gt 5 ]; then
            tput clear
            more $OUTPUTDIR/${no_file[$choice]}
            GET_CURSOR
        else
            lne=`expr $lne + 2`
            tput cup $lne $cl
            echo -n "File is empty. Either test was not run."
            let lne++
            tput cup $lne $cl
            echo -n "Or the snapshots do not differ."
        fi
        lne=`expr $lne + 2`
        tput cup $lne $cl
        echo -n "Please press <ENTER> to continue."
        read
    ;;
0) echo ; echo ; exit
    ;;
*)
    lne=`expr $lne + 2`
    tput cup $lne $cl
    echo -n "Choice Invalid."
    let lne++
    tput cup $lne $cl
    echo -n "Please press <ENTER> to continue."
    read
;;
esac
done
