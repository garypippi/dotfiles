#!/bin/sh

file="$HOME/Pictures/Capture/`date +%Y%m%d%H%M%S`.png"

slurp | grim -g - $file
wl-copy < $file

notify-send Copied.
