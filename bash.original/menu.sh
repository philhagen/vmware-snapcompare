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
tput rmso
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "1) Select Snapshots to Compare"
let lne++
tput cup $lne $cl
echo -n "2) View Selected Snapshots"
let lne++
tput cup $lne $cl
echo -n "3) View Files Deleted"
let lne++
tput cup $lne $cl
echo -n "4) View New Files Added"
let lne++
tput cup $lne $cl
echo -n "5) View Files Edited [Modification Time]"
let lne++
tput cup $lne $cl
echo -n "6) View Files Changed [Change Time]"
let lne++
tput cup $lne $cl
echo -n "7) View SETUID/SETGUID Changes"
let lne++
tput cup $lne $cl
echo -n "8) View Analysis Result Files"
let lne++
tput cup $lne $cl
echo -n "9) Compute MD5 & SHA1 Hashes"
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "0) EXIT"
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "Please enter choice [1-9,0]: "
CTRAP; read choice
case $choice in
    1) $MENUPATH/select_files.sh
    ;;
    2) $MENUPATH/view_files.sh
    ;;
    3) $MENUPATH/deleted_files.sh
    ;;
    4) $MENUPATH/added_files.sh
    ;;
    5) $MENUPATH/edited_files.sh
    ;;
    6) $MENUPATH/change_files.sh
    ;;
    7) $MENUPATH/setid_changes.sh
    ;;
    8) $MENUPATH/result_files.sh
    ;;
    9) $MENUPATH/check_md5.sh
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
