#!/bin/bash

FRAGMENTS=(${1//:/ })

if [ "${FRAGMENTS[0]}" == "file" ]; then
    xdg-open ${FRAGMENTS[1]}
else
    xdg-open $1
fi
