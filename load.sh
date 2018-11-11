#!/bin/sh
if [ -d "${PWD}/.envs" ]; then
    echo "Checking env store..."
    OLD_IFS=${IFS}
    IFS=';'
    for file in $(find ${PWD}/.envs -maxdepth 1 -iname '*.envs' -exec basename {} .envs ';' | tr '\n' ';'); do
        export ${file}="$(cat ${PWD}/.envs/${file}.envs)"
        eval "echo \"${file}: \${${file}}\""
    done
    IFS=${OLD_IFS}
else
    echo "SKIPPING..."
fi
