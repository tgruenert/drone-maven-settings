FROM alpine:latest

COPY --from=kamalook/envsubst /envsubst /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/
COPY settings.xml /usr/local/share/maven/

ENTRYPOINT [ "docker-entrypoint.sh" ]
