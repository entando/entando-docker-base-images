ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-base-common:$ENTANDO_IMAGE_VERSION as entando-base-common

FROM centos/postgresql-95-centos7:9.5
LABEL io.openshift.s2i.destination="/opt/s2i/destination" \
      maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Postgresql Database Image for building and running Entando applications" \
      io.k8s.display-name="Postgresql Database Image for Entando 5+"
ARG ENTANDO_VERSION
ARG MAVEN_MIRROR_FOR_DOCKER_BUILDS
ENV MAVEN_VERSION="3.5.4" \
    JAVA_HOME="/usr/lib/jvm/java-1.8.0" \
    ENTANDO_VERSION=$ENTANDO_VERSION \
    USERID_TO_USE=26 \
    STI_SCRIPTS_PATH="/usr/libexec/s2i" \
    ENTANDO_COMMON_PATH="/entando-common"


#Change to root for installation operations
USER root
RUN INSTALL_PKGS="ant tar curl java-1.8.0-openjdk java-1.8.0-openjdk-devel" && \
  yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
  rpm -V $INSTALL_PKGS && \
  yum clean all -y && \
  (curl -v https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -zx -C /usr/local) && \
  ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
  mkdir -p $HOME/.m2 && chmod ug+rw $HOME/.m2 && chown $USERID_TO_USE:0 $HOME/.m2
ENV PORTDB_USERNAME=agile \
    PORTDB_PASSWORD=agile \
    SERVDB_USERNAME=agile1 \
    SERVDB_PASSWORD=agile1 \
    ADMIN_PASSWORD=postgres \
    PORTDB_DATABASE=entandoPort \
    SERVDB_DATABASE=entandoServ \
    PORTDB_DRIVER=postgresql \
    SERVDB_DRIVER=postgresql \
    PORTDB_JNDI="java:jboss/datasources/entandoPortDataSource" \
    SERVDB_JNDI="java:jboss/datasources/entandoServDataSource" \
    POSTGRESQL_MAX_PREPARED_TRANSACTIONS=0 \
    POSTGRESQL_SHARED_BUFFERS=32MB \
    ENV_FILES="" \
    PREPARE_DATA="true" \
    DB_ENVIRONMENT="production" \
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
    LC_ALL="en_US.UTF-8"
COPY --chown=26:0 ./postgresql /usr/share/container-scripts/postgresql
COPY --chown=26:0 --from=entando-base-common /opt/app-root/src/.m2 $HOME/.m2
COPY --chown=26:0 --from=entando-base-common /opt/app-root/src/jetty-runner /jetty-runner
COPY --chown=26:0 --from=entando-base-common ${ENTANDO_COMMON_PATH} ${ENTANDO_COMMON_PATH}
COPY --chown=26:0 ./s2i/bin/ $STI_SCRIPTS_PATH
COPY test /etc/postgresql-test-datasources
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8 && \
    chmod ug+rw /usr/lib/locale/locale-archive && \
    mkdir -p /opt/s2i/destination && chmod -R ug+rw /opt/s2i/destination && chown -R $USERID_TO_USE:0 /opt/s2i/destination && \
    mkdir -p /entando-data/databases  && chown -Rf $USERID_TO_USE:0 /entando-data/ && chmod -Rf ug+rw /entando-data/ && \
    mkdir -p /entando-data-templates/databases  && chown -Rf $USERID_TO_USE:0 /entando-data-templates/ && chmod -Rf ug+rw /entando-data-templates/ && \
    mkdir -p /var/log/entando && chown -Rf $USERID_TO_USE:0 /var/log/entando && chmod -Rf ug+rw /var/log/entando

USER $USERID_TO_USE
#And end by making the user postgres again
CMD "${STI_SCRIPTS_PATH}/run"
