#!/bin/sh

file=`echo $1 | egrep 'Compte.*Rele.*_n_[0-9][0-9][0-9]_'` 

if [ -z "$file" ]
then
    exit
fi

year=2014
count=36016373000

pdftotext -layout $1 - |\
    egrep '^ *[0-9][0-9]\.[0-9][0-9] '  |\
    sed -e "s/^ *//" |\
    sed -e "s/^\([0-9][0-9]\.[0-9][0-9]\) *\([0-9][0-9]\.[0-9][0-9]\) */\1/" |\
    sed -e "s/\([0-9][0-9]\)\.\([0-9][0-9]\) */\1\/\2\/$year /" |\
    sed -r -e 's/^.{66}/&;/'  -e's/^.{11}/&;/' |\
    sed -e "s/.*/$count;\0/"



# vim: set tw=0
