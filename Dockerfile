# FROM dronee/plugin-base
FROM dronee/maven-settings

# COPY docker-entrypoint.sh /usr/local/bin/
COPY settings.tpl.xml /usr/local/share/maven/

# ENTRYPOINT [ "docker-entrypoint.sh" ]
