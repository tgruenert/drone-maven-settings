#!/bin/sh
set -euo pipefail

function isenv {
	env | grep -q "^$1="
}

MAVEN_REVISION=${DRONE_SEMVER:-${DRONE_BRANCH/\//-}}
MAVEN_SHA1=${DRONE_COMMIT_SHA:0:8}
MAVEN_CHANGELIST=$(test -z "$DRONE_SEMVER" && echo "-SNAPSHOT" || true)

export PROPERTIES=$(env2args dot '<$k>$v</$k>' PLUGIN_PROPERTY_)
for _env in $(env2args); do export $_env; done

isenv LOCAL_CACHE && test "${LOCAL_CACHE:0:1}" != "/" && export LOCAL_CACHE="$PWD/$LOCAL_CACHE"
isenv LOCAL_CACHE || export LOCAL_CACHE='${user.home}/.m2/repository'
isenv OUTPUT || test -d .mvn || mkdir .mvn
isenv OUTPUT || OUTPUT=".mvn/release-settings.xml" && echo -n " -e -B -Drevision=$MAVEN_REVISION -Dsha1=$MAVEN_SHA1 -Dchangelist=$MAVEN_CHANGELIST -s $OUTPUT" >> .mvn/maven.config
isenv DRONE_WORKSPACE && echo "Rendering $OUTPUT" || OUTPUT="/dev/stdout"

if isenv 'TEMPLATE'; then
	echo $TEMPLATE | envsubst -no-unset -o $OUTPUT
else
	cat /usr/local/share/maven/settings.tpl.xml | envsubst -no-unset -o $OUTPUT
fi

echo "maven.config: $(cat .mvn/maven.config)"
