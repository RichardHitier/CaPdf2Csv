#!/bin/sh
#
# Transform pdf files from the bank
# to .csv file importable to skrooge
# usage: ./seconddraw.sh Comptexxxxxx.pdf [command]
# 


# Transformations:
#

# convert pdf to text
raw()
{
    # 0. to text
    pdftotext -layout $1 - |
    cat 
}

# convert raw to csv 
totxt()
{
    cat |
    # 1. only get lines with proper date format at beginning
    egrep '^ *[0-9][0-9]\.[0-9][0-9] '  |
    # 2. then get rid of trailing spaces
    sed -e "s/^ *//" |
    # 3. keep only one of the 2 dates
    sed -e "s/^\([0-9][0-9]\.[0-9][0-9]\) *\([0-9][0-9]\.[0-9][0-9]\) */\1 /" |
    # 4. make proper date 
    sed -e "s/\([0-9][0-9]\)\.\([0-9][0-9]\) */\1\/\2\/$year /" |
    # 5. add ';' as field separator
    sed -r -e 's/^.{66}/&;/'  -e 's/^.{11}/&;/' |
    # 6. get rid of trailing chars and align last column
    sed -e "s/ *¨$//"  -e "s/; *\([^;]*\)$/; \1/" |
    # 7. '-' everywhere unless if "Virement" or "Rem Chq"
    sed -e "/\(Virement\|Rem Chq\)/!s/; *\([^;]*\)$/;-\1/" |
    # 8. prepend with account number
    sed -e "s/.*/$account;\0/" |
    # trick for commenting upper lines if necessary
    cat
}

# rewrite year of december dates
toprevyear()
{
    cat | 
    sed -e "s#/12/$year#/12/$prevyear#"
}

# Usage
#
usage()
{
    cat << EOF
Usage:
    $0 filename [command]

where command is one of:

    raw
    txt
    whole

EOF
}

################################################################################
# Main stuff

# 1. give file as arg
#
[ -z $1 ] && usage && exit

# 2. guess if we are dealing with the second file format
# (from 001 to 012 in one year )
#
file=`echo $1 | egrep 'Compte.*Rele.*_n_[0-9][0-9][0-9]_'` 

if [ -z "$file" ]
then
    exit
fi

# 3. set some vars
#
year=`echo $file |cut -d"_" -f9`
account=`echo $file |cut -d"_" -f2`
numfile=`echo $file | cut -d"_" -f5`

prevyear=`echo "$year - 1" |bc`

# 4. compute command
#
case $2 in
    # only pdf2txt
    raw)
        raw $1
        exit
        ;;
    # from raw to csv
    txt)
        cat $1 | totxt
        exit
        ;;
    # whole change from pdf to csv 
    whole)
        # change december year based on file number
        if [ $numfile -eq '001' ]
        then
            raw $1 | totxt | toprevyear
        else
            raw $1 | totxt 
        fi
        ;;
    *)
        echo "nothing to do"
        ;;
esac


# vim: tw=0
