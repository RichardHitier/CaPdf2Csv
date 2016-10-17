#!/bin/sh

help()
{
    echo $1
    cat << .END
    The help of the $0
.END
}


while getopts "hdl:" flag
do
    case "$flag" in
        d) BIN="echo BIN";;
        h) help;;
        l) 
            exec >> $OPTARG
            exec 2>> $OPTARG
            echo
            echo "-----------------------------"
            date
            echo "-----------------------------"
         ;;
    esac
done

pdftotext -layout $1 - |\
egrep '^ *[0-9][0-9]\.[0-9][0-9] '  |\
sed -e "s/^ *//" |\
sed -e "s/^\([0-9][0-9]\.[0-9][0-9]\) *\([0-9][0-9]\.[0-9][0-9]\) */\1/" |\
sed -e "s/\([0-9][0-9]\.[0-9][0-9]\) */\1 /"
grep -v yahaha

# vim: set tw=0
