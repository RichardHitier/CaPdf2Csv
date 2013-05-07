#!/bin/sh

dirs="2009 2010 2011 2012 2013"

for dir in ${dirs}
do
    cd ${dir}
    make -f ../Makefile.pdf2skg clean-all
    make -f ../Makefile.pdf2skg year=${dir}
    #cat ${dir}.csv >> ../allyears.csv
    #cd ..
done
