#!/bin/sh
#
# Transform pdf files from the bank
# to .csv file importable to skrooge


# guess if we are dealing with the second pdf format
#
file=`echo $1 | egrep 'Compte.*Rele.*_n_[0-9][0-9][0-9]_'` 

if [ -z "$file" ]
then
    exit
fi

# set some vars
#
year=`echo $file |cut -d"_" -f9`
account=`echo $file |cut -d"_" -f2`


# Transformations:

# 0. to text
pdftotext -layout $1 - |
# 1. only get lines with proper date format at beginning
egrep '^ *[0-9][0-9]\.[0-9][0-9] '  |
# 2. then get rid of trailing spaces
sed -e "s/^ *//" |
# 3. keep only one of the 2 dates
sed -e "s/^\([0-9][0-9]\.[0-9][0-9]\) *\([0-9][0-9]\.[0-9][0-9]\) */\1 /" |
# 4. make proper date (TODO: year-1 if month = 1 && filenum == 001 )
sed -e "s/\([0-9][0-9]\)\.\([0-9][0-9]\) */\1\/\2\/$year /" |
# 5. add ';' as field separator
sed -r -e 's/^.{66}/&;/'  -e 's/^.{11}/&;/' |
# 6. get rid of trailing chars and align last column
sed -e "s/ *¨$//"  -e "s/; *\([^;]*\)$/; \1/" |
# 7. '-' everywhere unless if "Virement" or "Rem Chq"
sed -e "/\(Virement\|Rem Chq\)/!s/; *\([^;]*\)$/;-\1/" |
# 8. prepend with account number
sed -e "s/.*/$account;\0/" |
cat



# vim: tw=0
