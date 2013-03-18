#!/bin/bash

. $( dirname $0 )/snapcompare_common.sh

$MENUPATH/deleted_files.sh

$MENUPATH/added_files.sh

$MENUPATH/edited_files.sh

$MENUPATH/change_files.sh

$MENUPATH/setid_changes.sh
