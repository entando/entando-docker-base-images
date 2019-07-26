FROM openjdk:8-jdk-alpine
ARG ENTANDO_VERSION
ARG ENTANDO_IMAGE_VERSION
ARG MAVEN_MIRROR_FOR_DOCKER_BUILDS
ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    USERID_TO_USE=1001 \
    ENTANDO_COMMON_PATH="/app/entando-common"
RUN apk add --no-cache curl tar bash procps && \
    adduser -u 1001 -h /app  -s /bin/sh -G root -D java

ARG MAVEN_VERSION=3.5.4
ARG USER_HOME_DIR="/app"
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
COPY --chown=1001:0 ./entando-common /app/entando-common
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
USER $USERID_TO_USE
RUN cd $ENTANDO_COMMON_PATH/sample-driver-installer/ \
    && ./install.sh \
    && mkdir -p $HOME/libs \
    && chmod -Rf ug+rw  $HOME


#Now we have all the dependencies sitting at $HOME./m2/settings
