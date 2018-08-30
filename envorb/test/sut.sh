#!/bin/sh
source /usr/local/bin/envload
if [ ! "${ENV_TEST}" -eq "SUCCESS" ]; then
    echo "ENV_TEST not properly loaded"
    exit 1
fi
