#!/bin/sh
set -euo pipefail

function isenv {
	env | grep -q "^$1="
}

isenv LOCAL_CACHE || export LOCAL_CACHE='${user.home}/.m2/repository'
isenv OUTPUT || test -d .mvn || mkdir .mvn
isenv OUTPUT || OUTPUT=".mvn/release-settings.xml" && echo " -s $OUTPUT" >> .mvn/maven.config
isenv CI_WORKSPACE && echo "Rendering $OUTPUT" || OUTPUT="/dev/stdout"

export PROPERTIES=$(env2args dot '<$k>$v</$k>' PLUGIN_PROPERTY_)

if isenv 'TEMPLATE'; then
	echo $TEMPLATE | envsubst -no-unset -o $OUTPUT
else
	cat /usr/local/share/maven/settings.tpl.xml | envsubst -no-unset -o $OUTPUT
fi
