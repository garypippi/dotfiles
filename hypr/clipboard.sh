#!/bin/sh
set -euo pipefail

# Path to clipboard
file=/tmp/clipboard

# Clear clipboard content
> $file

if `alacritty --class 'chotto' -e nvim -c 'startinsert' $file`; then
    head -c -1 $file | wl-copy
    notify-send Copied.
fi
