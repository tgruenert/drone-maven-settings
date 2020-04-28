#!/bin/bash
set -euo pipefail

_params=()
for _kv in $(env); do
    _key=$(echo $_kv | cut -d '=' -f 1)
    _val=$(echo $_kv | cut -d '=' -f 2)
    if [[ "$_key" = PLUGIN_* ]]; then
        _key=${_key#PLUGIN_}
        _params+=("--$(echo $_key | tr '[:upper:]' '[:lower:]' | sed -E 's/_(.)/\U\1/g')=$_val")
        test -v $_key || export $_key=$_val
    fi
done

mkdir -p $HOME/.m2
echo "${TEMPLATE:-$(cat /usr/local/share/maven/settings.tpl.xml)}" | envsubst -no-unset -o ${OUTPUT:-$HOME/.m2/settings.xml}
