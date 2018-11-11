#!/bin/sh
if [ -d "${PWD}/.envs" ]; then
    echo "Checking env store..."
    OLD_IFS=${IFS}
    IFS=';'
    for file in $(find ${PWD}/.envs -maxdepth 1 -iname '*.env' -exec basename {} .env ';' | tr '\n' ';'); do
        export ${file}="$(cat ${PWD}/.envs/${file}.env)"
        eval "echo \"${file}: \${${file}}\""
    done
    IFS=${OLD_IFS}
else
    echo "SKIPPING..."
fi
