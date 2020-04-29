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

test -v LOCAL_CACHE || export LOCAL_CACHE='${user.home}/.m2/repository'
test -v OUTPUT || test -d .mvn || mkdir .mvn
test -v OUTPUT || OUTPUT=".mvn/release-settings.xml" && echo " -s $OUTPUT" >> .mvn/maven.config
test -v CI_WORKSPACE || OUTPUT="/dev/stdout"
echo ${TEMPLATE:-$(cat /usr/local/share/maven/settings.tpl.xml)} | envsubst -no-unset -o $OUTPUT
