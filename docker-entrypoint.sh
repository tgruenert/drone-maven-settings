#!/bin/sh
set -euo pipefail

mkdir -p $HOME/.m2

for E in $(env); do
    KEY=$(echo $E | cut -d '=' -f 1)
    VAL=$(echo $E | cut -d '=' -f 2)
    test -n "${KEY#PLUGIN_}" && export ${KEY#PLUGIN_}=$VAL
done

echo "${TEMPLATE:-$(cat /usr/local/share/maven/settings.tpl.xml)}" | envsubst -no-unset -o ${OUTPUT:-$HOME/.m2/settings.xml}
