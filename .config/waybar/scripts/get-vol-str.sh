#!/bin/bash

pactl get-sink-volume @DEFAULT_SINK@ | awk '{match($0,/([0-9]+)%/,a);print(a[1]);}' | head -c -1
