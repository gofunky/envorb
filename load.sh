#!/bin/sh
if [ -d "${PWD}/env" ]; then
    echo "Checking env store..."
    OLD_IFS=${IFS}
    IFS=';'
    for file in $(find ${PWD}/env -maxdepth 1 -iname '*.env' -exec basename {} .env ';' | tr '\n' ';'); do
        export ${file}="$(cat ${PWD}/env/${file}.env)"
        eval "echo \"${file}: \${${file}}\""
    done
    IFS=${OLD_IFS}
else
    echo "SKIPPING..."
fi
