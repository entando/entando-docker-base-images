# This image provides a very lightweight base for building and running Entando
# EAP based applications with an embedded Derby db.
# It builds using maven and runs the resulting artifacts on EAP

ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-eap71-base:${ENTANDO_IMAGE_VERSION}
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando clustered applications on EAP 7.1" \
      io.k8s.display-name="Entando on EAP 7.1"
ARG ENTANDO_VERSION
ARG MAVEN_MIRROR_FOR_DOCKER_BUILDS
ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    USERID_TO_USE=185

COPY --chown=185:0 ./standalone-openshift.xml /opt/eap/standalone/configuration

ENV PORTDB_NONXA="true" \
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
    SPRING_PROFILES_ACTIVE="default"
