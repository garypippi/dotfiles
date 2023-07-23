#!/bin/bash

vol=`$HOME/.config/waybar/scripts/get-vol-str.sh`
len=`expr $vol / 5`
str=""
nel=`expr 20 - $len`


for i in `seq 1 $len`; do
    if [ "$i" -eq "10" ]; then
        str="$str<span bgcolor=\"#ACBCFF\" fgcolor=\"#000000\">${vol:0:1}</span>"
    elif [ "$i" -eq "11" ]; then
        str="$str<span bgcolor=\"#ACBCFF\" fgcolor=\"#000000\">${vol:1:1}</span>"
    elif [ "$i" -eq "12" ]; then
        str="$str<span bgcolor=\"#ACBCFF\" fgcolor=\"#000000\">${vol:2:1}</span>"
        if [ -z "${vol:2:3}" ]; then
            str="$str<span bgcolor=\"#ACBCFF\"> </span>"
            str="$str<span bgcolor=\"#ACBCFF\"> </span>"
        fi
    else
        str="$str<span bgcolor=\"#ACBCFF\"> </span>"
        str="$str<span bgcolor=\"#ACBCFF\"> </span>"
    fi
done

for i in `seq 1 $nel`; do
    if [ $((i + len)) -eq "10" ]; then
        str="$str<span bgcolor=\"#000000\">${vol:0:1}</span>"
    elif [ "$((i + len))" -eq "11" ]; then
        str="$str<span bgcolor=\"#000000\">${vol:1:1}</span>"
        if [ -z "${vol:1:2}" ]; then
            str="$str<span bgcolor=\"#000000\"> </span>"
            str="$str<span bgcolor=\"#000000\"> </span>"
        fi
    else
        str="$str<span bgcolor=\"#000000\"> </span>"
        str="$str<span bgcolor=\"#000000\"> </span>"
    fi
done

echo $str;
