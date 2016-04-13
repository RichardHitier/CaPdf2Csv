#!/bin/bash

[ -z "$1" ] && { echo "give dir as arg"; exit ;}
[ -d "$1" ] || { echo "$1 not dir"; exit;}

cd $1

rename 's/Relev_(.*)/Compte_36016373000_Relevé$1/g' *
rename 's/%20/_/g' *
