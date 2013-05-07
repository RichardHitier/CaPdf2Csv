#!/bin/sh -x

help()
{
    echo $1
    cat << .END
    The help of the $0
.END
}


while getopts "hy:" flag
do
    case "$flag" in
        h) help;;
        y) 
            year=$OPTARG
         ;;
    esac
done

cd ${year}

rm *txt

for i in *pdf
do
    echo "texting $i"
    /usr/bin/pdftotext -layout $i
done

for i in *txt
do
    echo "grepping $i"
    dest=$(basename $i .txt)
    egrep '^ *[0-9][0-9] [0-9][0-9]' $i | sed -e "s/^ *\([0-9][0-9]\) \([0-9][0-9]\) \+\([^ ].*\)[0-9][0-9] [0-9][0-9]/\1\/\2\/${year};\3;/" > $dest-grepped.txt
    sed -e "/;\(VIR\|REMIS\)/!s/;\([^;]*\)$/;-\1/" $dest-grepped.txt > $dest-final.txt
done



cat ../heads.csv *final*> 36016373000.csv

# vim: tw=0
