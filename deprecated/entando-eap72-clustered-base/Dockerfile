# This image provides a very lightweight base for building and running Entando
# EAP based applications with an embedded Derby db.
# It builds using maven and runs the resulting artifacts on EAP
FROM entando/entando-base-common:6.3.2 AS entando-base-common

FROM registry.redhat.io/jboss-eap-7/eap72-openjdk11-openshift-rhel8:latest
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando clustered applications on EAP 7.2" \
      io.k8s.display-name="Entando on EAP 7.1"
ENV USERID_TO_USE=185 \
    STI_SCRIPTS_PATH="/usr/locmodulesal/s2i" \
    ENTANDO_COMMON_PATH="/entando-common"

COPY --chown=185:0 --from=entando-base-common  /opt/app-root/src/wildfly/modules /opt/eap/modules
COPY --chown=185:0 ./modules  /opt/eap/modules
COPY --chown=185:0 --from=entando-base-common /opt/app-root/src/.m2  $HOME/.m2
COPY --chown=185:0 --from=entando-base-common /opt/app-root/src/jetty-runner /jetty-runner
COPY --chown=185:0 --from=entando-base-common ${ENTANDO_COMMON_PATH} ${ENTANDO_COMMON_PATH}
COPY --chown=185:0 ./standalone-openshift.xml /opt/eap/standalone/configuration
COPY ./run ${STI_SCRIPTS_PATH}/run
ENV DATASOURCES="PORTDB,SERVDB" \
    PORTDB_NONXA="true" \
    PORTDB_JTA="false" \
    PORTDB_URL="jdbc:derby:/entando-data/databases/entandoPort;create=true" \
    PORTDB_JNDI="java:jboss/datasources/entandoPortDataSource" \
    PORTDB_DRIVER="derby" \
    PORTDB_USERNAME="agile" \
    PORTDB_PASSWORD="agile" \
    PORTDB_SERVICE_HOST="dummy" \
    PORTDB_SERVICE_PORT="1234" \
    PORTDB_BACKGROUND_VALIDATION="true" \
    PORTDB_EXCEPTION_SORTER="org.jboss.jca.adapters.jdbc.extensions.novendor.NullExceptionSorter" \
    PORTDB_BACKGROUND_VALIDATION_MILLIS="60000" \
    PORTDB_CONNECTION_CHECKER="org.jboss.jca.adapters.jdbc.extensions.novendor.NullValidConnectionChecker" \
    SERVDB_NONXA="true" \
    SERVDB_JTA="false" \
    SERVDB_URL="jdbc:derby:/entando-data/databases/entandoServ;create=true" \
    SERVDB_JNDI="java:jboss/datasources/entandoServDataSource" \
    SERVDB_DRIVER="derby" \
    SERVDB_USERNAME="agile" \
    SERVDB_PASSWORD="agile" \
    SERVDB_SERVICE_HOST="dummy" \
    SERVDB_SERVICE_PORT="1234" \
    SERVDB_BACKGROUND_VALIDATION="true" \
    SERVDB_BACKGROUND_VALIDATION_MILLIS="60000" \
    SERVDB_CONNECTION_CHECKER="org.jboss.jca.adapters.jdbc.extensions.novendor.NullValidConnectionChecker" \
    SERVDB_EXCEPTION_SORTER="org.jboss.jca.adapters.jdbc.extensions.novendor.NullExceptionSorter" \
    PREPARE_DATA="true" \
    DB_ENVIRONMENT="production" \
    DEPLOYMENTS_DIR="/opt/eap/standalone/deployments" \
    JBOSS_HOME="/opt/eap/" \
    ENTANDO_OIDC_ACTIVE="false" \
    ENTANDO_OIDC_AUTH_LOCATION="http://definitely.does.not.exist.com" \
    ENTANDO_OIDC_TOKEN_LOCATION="http://definitely.does.not.exist.com" \
    ENTANDO_OIDC_CLIENT_ID="dummy" \
    ENTANDO_OIDC_REDIRECT_BASE_URL="http://definitely.does.not.exist.com" \
    ALGO_DEFAULT_KEY="changeit" \
    KEYCLOAK_ENABLED="false" \
    KEYCLOAK_AUTH_URL="http://definitely.does.not.exist.com" \
    KEYCLOAK_REALM="dummy" \
    KEYCLOAK_CLIENT_ID="dummy" \
    KEYCLOAK_CLIENT_SECRET="dummy" \
    KEYCLOAK_PUBLIC_CLIENT_ID="dummy" \
    LOGFILEPREFIX="/var/log/entando/engine_" \
    LOGACTIVEFILEOUTPUT="true" \
    LOGNAME="/var/log/entando/engine.log" \
    LOGFILEROTATEPATTERN="/var/log/entando/engine_%i.log.gz" \
    RESOURCEDISKROOTFOLDER="/entando-data/resources/" \
    PROTECTEDRESOURCEDISKROOTFOLDER="/entando-data/protected/" \
    INDEXDISKROOTFOLDER="/tmp/entando-indices" \
    LC_ALL="en_US.UTF-8" \
    SPRING_PROFILES_ACTIVE="default" \
    JBOSS_MAX_POST_SIZE="1073741824" \
    APPBUILDERINTEGRATIONENABLED="true" \
    APPBUILDERBASEURL="/app-builder/"
USER root
RUN  yum install -y glibc-locale-source glibc-langpack-en procps && \
     localedef -c -f UTF-8 -i en_US en_US.UTF-8 && \
     chmod ug+rw /usr/lib/locale/locale-archive
RUN mkdir -p /entando-data/databases  && chown -Rf $USERID_TO_USE:0 /entando-data/ && chmod -Rf ug+rw /entando-data/ && \
    mkdir -p /entando-data-templates/databases  && chown -Rf $USERID_TO_USE:0 /entando-data-templates/ && chmod -Rf ug+rw /entando-data-templates/ && \
    mkdir -p /var/log/entando && chown -Rf $USERID_TO_USE:0 /var/log/entando && chmod -Rf ug+rw /var/log/entando

USER $USERID_TO_USE

CMD "${STI_SCRIPTS_PATH}/run"
#NB!!! Place the VOLUME declaration AFTER the state (permissions, ownership, content) of the volume has been set
VOLUME /entando-data
