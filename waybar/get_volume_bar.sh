#!/bin/bash
set -euo pipefail

volume=`pactl get-sink-volume @DEFAULT_SINK@ | awk '{match($0,/([0-9]+)%/,a);print(a[1]);}' | head -c -1`
output=""

bgColor="#000000"
fgColor="#FF52A2"

for i in {1..20}; do
    if [ $i -le `expr $volume / 5` ]; then
        if [ "$i" -eq "10" ]; then
            output="$output<span bgcolor=\"#FF52A2\" fgcolor=\"#EEEEEE\">${volume:0:1}</span>"
        elif [ "$i" -eq "11" ] && [ ! -z "${volume:1:1}" ]; then
            output="$output<span bgcolor=\"#FF52A2\" fgcolor=\"#EEEEEE\">${volume:1:1}</span>"
        elif [ "$i" -eq "12" ] && [ ! -z "${volume:2:1}" ]; then
            output="$output<span bgcolor=\"#FF52A2\" fgcolor=\"#EEEEEE\">${volume:2:1}</span>"
        else
            output="$output<span bgcolor=\"$fgColor\"> </span>"
            output="$output<span bgcolor=\"$fgColor\"> </span>"
        fi
    else
        if [ "$i" -eq "10" ]; then
            output="$output<span bgcolor=\"#000000\">${volume:0:1}</span>"
        elif [ "$i" -eq "11" ] && [ ! -z "${volume:1:1}" ]; then
            output="$output<span bgcolor=\"#000000\">${volume:1:1}</span>"
        else
            output="$output<span bgcolor=\"$bgColor\"> </span>"
            output="$output<span bgcolor=\"$bgColor\"> </span>"
        fi
    fi
done

echo $output
