# This image provides a base for building and running Entando WildFly based applications.
# It builds using maven and runs the resulting artifacts on WildFly 12.0.0 Final
ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-base-common:$ENTANDO_IMAGE_VERSION AS entando-base-common

# Note to self: we couldn't use entando-wildfly12-quickstart-openshift because of permissions on Volumes TODO see if it is fixable
FROM openshift/wildfly-120-centos7:latest
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando quickstart applications on WildFly 12.0.0.Final" \
      io.k8s.display-name="Entando on WildFly 12.0.0.Final"
ARG ENTANDO_VERSION
ARG MAVEN_MIRROR_FOR_DOCKER_BUILDS
ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    USERID_TO_USE=1001 \
    STI_SCRIPTS_PATH="/usr/libexec/s2i"\
    ENTANDO_COMMON_PATH="/entando-common"
USER root
RUN yum install -y ImageMagick && yum clean all
COPY --chown=1001:0 ./contrib/wildfly-configuration/standalone.xml /wildfly/standalone/configuration/standalone.xml
COPY --chown=1001:0 ./s2i/bin ${STI_SCRIPTS_PATH}
COPY --chown=1001:0 --from=entando-base-common /opt/app-root/src/wildfly/modules /wildfly/modules
COPY --chown=1001:0 --from=entando-base-common /opt/app-root/src/jetty-runner /jetty-runner
COPY --chown=1001:0 --from=entando-base-common /opt/app-root/src/.m2 $HOME/.m2
COPY --chown=1001:0 --from=entando-base-common ${ENTANDO_COMMON_PATH} ${ENTANDO_COMMON_PATH}

ENV PORTDB_NONXA="true" \
    PORTDB_JTA="false" \
    PORTDB_URL="jdbc:derby:/entando-data/databases/entandoPort;create=true" \
    PORTDB_JNDI="java:jboss/datasources/entandoPortDataSource" \
    PORTDB_DRIVER="derby" \
    PORTDB_USERNAME="agile" \
    PORTDB_PASSWORD="agile" \
    PORTDB_SERVICE_HOST="dummy" \
    PORTDB_SERVICE_PORT="1527" \
    PORTDB_CONNECTION_CHECKER="org.jboss.jca.adapters.jdbc.extensions.novendor.NullValidConnectionChecker" \
    PORTDB_EXCEPTION_SORTER="org.jboss.jca.adapters.jdbc.extensions.novendor.NullExceptionSorter" \
    SERVDB_NONXA="true" \
    SERVDB_JTA="false" \
    SERVDB_URL="jdbc:derby:/entando-data/databases/entandoServ;create=true" \
    SERVDB_JNDI="java:jboss/datasources/entandoServDataSource" \
    SERVDB_DRIVER="derby" \
    SERVDB_USERNAME="agile" \
    SERVDB_PASSWORD="agile" \
    SERVDB_SERVICE_HOST="dummy" \
    SERVDB_SERVICE_PORT="1527" \
    SERVDB_CONNECTION_CHECKER="org.jboss.jca.adapters.jdbc.extensions.novendor.NullValidConnectionChecker" \
    SERVDB_EXCEPTION_SORTER="org.jboss.jca.adapters.jdbc.extensions.novendor.NullExceptionSorter" \
    PREPARE_DATA="true" \
    DB_ENVIRONMENT="production" \
    JBOSS_HOME="/wildfly/" \
    DEPLOYMENTS_DIR="/wildfly/standalone/deployments" \
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
    LOGNAME="/var/log/entando/engine.log" \
    LOGACTIVEFILEOUTPUT="true" \
    LOGFILEROTATEPATTERN="/var/log/entando/engine_%i.log.gz" \
    RESOURCEDISKROOTFOLDER="/entando-data/resources/" \
    PROTECTEDRESOURCEDISKROOTFOLDER="/entando-data/protected/" \
    INDEXDISKROOTFOLDER="/tmp/entando-indices" \
    LC_ALL="en_US.UTF-8" \
    SPRING_PROFILES_ACTIVE="default" \
    JBOSS_MAX_POST_SIZE="1073741824"
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8 && \
    chmod ug+rw /usr/lib/locale/locale-archive && \
    mkdir -p /entando-data/databases  && chown -Rf $USERID_TO_USE:0 /entando-data/ && chmod -Rf ug+rw /entando-data/ && \
    mkdir -p /entando-data-templates/databases  && chown -Rf $USERID_TO_USE:0 /entando-data-templates/ && chmod -Rf ug+rw /entando-data-templates/ && \
    mkdir -p /var/log/entando && chown -Rf $USERID_TO_USE:0 /var/log/entando && chmod -Rf ug+rw /var/log/entando

USER $USERID_TO_USE

CMD "${STI_SCRIPTS_PATH}/run"
#NB!!! Place the VOLUME declaration AFTER the state (permissions, ownership, content) of the volume has been set
VOLUME /entando-data
