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
echo -n "Compute MD5 & SHA1 Hashes"
tput rmso
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "1) Compute Hash for Files Already Selected"
let lne++
tput cup $lne $cl
echo -n "2) Compute Hash for Another File"
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "0) EXIT"
lne=`expr $lne + 2`
tput cup $lne $cl
echo -n "Please enter choice [1-2,0]: "
CTRAP; read choice
case $choice in
    1)
        lne=`expr $lne + 2`
        tput cup $lne $cl
        echo -n "Computing MD5 & SHA1 for `sed -n 1p $DATAFILE1`"
        let lne++
        tput cup $lne $cl
        echo "Please be patient, this may take a while."
        lne=`expr $lne + 2`
        tput cup $lne $cl
        /usr/bin/md5sum "`sed -n 1p $DATAFILE1`"
        lne=`expr $lne + 2`
        tput cup $lne $cl
        /usr/bin/sha1sum "`sed -n 1p $DATAFILE1`"
        lne=`expr $lne + 2`
        tput cup $lne $cl
        echo -n "Computing MD5 & SHA1 for `sed -n 2p $DATAFILE1`"
        let lne++
        tput cup $lne $cl
        echo "Please be patient, this may take a while."
        lne=`expr $lne + 2`
        tput cup $lne $cl
        /usr/bin/md5sum "`sed -n 2p $DATAFILE1`"
        lne=`expr $lne + 2`
        tput cup $lne $cl
        /usr/bin/sha1sum "`sed -n 2p $DATAFILE1`"
        lne=`expr $lne + 2`
        tput cup $lne $cl
        echo -n "Please press <ENTER> to continue."
        read
    ;;
    2)
        function PATH_1 {
            lne=`expr $lne + 2`
            tput cup $lne $cl
            echo -n "Please input complete path of file for MD5 computation"
            let lne++
            tput cup $lne $cl
            echo -n "PATH: "
            read path1
            if [ -z "$path1" ]; then
                let lne++
                tput cup $lne $cl
                echo -n "Path cannot be left empty."
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
                    lne=`expr $lne + 2`
                    tput cup $lne $cl
                    echo -n "Computing MD5 & SHA1 for \"$path1\""
                    let lne++
                    tput cup $lne $cl
                    echo "Please be patient, this may take a while."
                    lne=`expr $lne + 2`
                    tput cup $lne $cl
                    /usr/bin/md5sum "$path1"
                    lne=`expr $lne + 2`
                    tput cup $lne $cl
                    /usr/bin/sha1sum "$path1"
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
