FROM busybox:latest

ENV USERID_TO_USE=1001 \
    ENTANDO_COMMON_PATH="/entando-common" \
    HOME=opt/app-root/src
COPY --chown=1001:0 ./entando-dependencies-bootstrap "${ENTANDO_COMMON_PATH}"
USER $USERID_TO_USE
COPY --chown=1001:0 ./settings.xml $HOME/.m2/settings.xml
#RUN cd $ENTANDO_COMMON_PATH/sample-driver-installer/ && ./install.sh && chmod -Rf ug+rw  $HOME/.m2

ENV PORTDB_NONXA="true" \
    PORTDB_JTA="false" \
    PORTDB_URL="jdbc:derby:/entando-data/databases/entandoPort;create=true" \
    PORTDB_JNDI="java:jboss/datasources/entandoPortDataSource" \
    PORTDB_DRIVER="derby" \
    PORTDB_USERNAME="agile" \
    PORTDB_PASSWORD="agile" \
    PORTDB_SERVICE_HOST="dummy" \
    PORTDB_SERVICE_PORT="1527" \
    SERVDB_NONXA="true" \
    SERVDB_JTA="false" \
    SERVDB_URL="jdbc:derby:/entando-data/databases/entandoServ;create=true" \
    SERVDB_JNDI="java:jboss/datasources/entandoServDataSource" \
    SERVDB_DRIVER="derby" \
    SERVDB_USERNAME="agile" \
    SERVDB_PASSWORD="agile" \
    SERVDB_SERVICE_HOST="dummy" \
    SERVDB_SERVICE_PORT="1527"
USER root
RUN mkdir -p /entando-data/databases  && chown -Rf $USERID_TO_USE:0 /entando-data/ && chmod -Rf ug+rw /entando-data/ && \
    mkdir -p /entando-data-templates && chown -Rf $USERID_TO_USE:0 /entando-data-templates/ && chmod -Rf ug+rw /entando-data-templates/

COPY --chown=1001:0 ./entando-common "$ENTANDO_COMMON_PATH"
COPY --chown=1001:0 ./jetty-runner $HOME/jetty-runner
USER $USERID_TO_USE


#Now we have all the dependencies sitting at $HOME./m2/settings
