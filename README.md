# IMPORTANT - DEPRECATED REPOSITORY

This repository is to be considered deprecated in favor of the following ones:
- https://github.com/entando/entando-app-engine-base - Docker base images for Wildfly/EAP
- https://github.com/entando/entando-java-base - Docker base image for Java based applications

# How to build and push the Docker base images

Please note that this project is not being built on GitHub pipelines yet. All the images should be built and pushed manually to DockerHub, so to decide which is the new version, you should check the latest one on DockerHub.

````
docker login # Login to Dockerhub
docker build . -t entando/entando-base-common:<version>
docker push entando/entando-base-common:<version>
````

## Procedure for Apple M1

You can build linux/amd64 images with the help of `buildx` plugin (embedded in Docker Desktop)

````
# Build and push to DockerHub
docker buildx build --platform linux/amd64 . -t entando/entando-base-common:<version> --push

# Build and push to local registry
docker buildx build --platform linux/amd64 . -t entando/entando-base-common:<version> --output type=docker

````

# Common Docker image environment variables
````
:PORTDB_URL: the full JDBC connection string used to connect to the Entando PORT database
:PORTDB_DATABASE: the name of the Entando PORT database that is created and hosted in the image
:PORTDB_JNDI: the full JNDI name where the Entando PORT datasource will be made available to the Entando Engine JEE application
:PORTDB_DRIVER: the name of the driver for the Entando PORT database as configured in the JEE application server
:PORTDB_USERNAME: the username of the user that has read/write access to the Entando PORT database
:PORTDB_PASSWORD: the password of the above-mentioned username.
:PORTDB_SERVICE_HOST: the  name of the server that hosts the Entando PORT database.
:PORTDB_SERVICE_PORT: the port on the above-mentioned server that serves the Entando PORT database. Generally we keep to the default port for each RDBMS, e.g. for PostgreSQL it is 5432
:SERVDB_URL: the full JDBC connection string used to connect to the Entando SERV database
:SERVDB_DATABASE: - the name of the Entando SERV database that is created and hosted in the image
:SERVDB_JNDI: the full JNDI name where the Entando SERV datasource will be made available to the Entando Engine JEE application
:SERVDB_DRIVER: the name of the driver for the Entando SERV database as configured in the JEE application server
:SERVDB_USERNAME: the username of the user that has read/write access to the Entando SERV database. For compatibility with mvn jetty:run, please keep this the same as PORTDB_USERNAME
:SERVDB_PASSWORD: the password of the above-mentioned username.  For compatibility with mvn jetty:run, please keep this the same as PORTDB_PASSWORD
:SERVDB_SERVICE_HOST: the  name of the server that hosts the Entando SERV database
:SERVDB_SERVICE_PORT: the port on the above-mentioned server that serves the Entando SERV database. Generally we keep to the default port for each RDBMS, e.g. for PostgreSQL it is 5432
:ADMIN_USERNAME: the username of a user that has admin rights on both the SERV and PORT databases. For compatibility with Postgresql, keep this value to 'postgres'
:ADMIN_PASSWORD: the password of the above-mentioned username.
:KIE_SERVER_BASE_URL: The base URL where a KIE Server instance is hosted, e.g. http://entando-kieserver701.apps.serv.run/
:KIE_SERVER_USERNAME: The username of a user that be used to log into the above-mentioned KIE Server
:KIE_SERVER_PASSWORD: The password of the above-mentioned KIE Server user.
:ENTANDO_OIDC_ACTIVE: set this variable's value to "true" to activate Entando's Open ID Connect and the related OAuth authentication infrastructure. If set to "false" all the subsequent OIDC  variables will be ignored. Once activated, you may need to log into Entando using the following url: <application_base_url>/<lang_code>/<any_public_page_code>.page?username=<MY_USERNAME>&password=<MY_PASSWORD>
:ENTANDO_OIDC_AUTH_LOCATION: the URL of the authentication service, e.g. the 'login page' that Entando needs to redirect the user to in order to  allow the OAuth provider to authenticate the user.
:ENTANDO_OIDC_TOKEN_LOCATION: the URL of the token service where Entando can retrieve the OAuth token from after authentication
:ENTANDO_OIDC_CLIENT_ID: the Client ID that uniquely identifies the Entando App in the OAuth provider's configuration
:ENTANDO_OIDC_REDIRECT_BASE_URL: the optional base URL, typically the protocol, host and port (https://some.host.com:8080/) that will be prepended to the path segment of the URL requested by the user and provided as a redirect URL to the OAuth provider. If empty, the requested URL will be used as is.
:DOMAIN:  the HTTP URL on which the associated Entando Engine instance will be served
:CLIENT_SECRET: the secret associated with the 'appbuilder' Oauth Client ID in the Entando OAuth infrastructure.
:JGROUPS_ENCRYPT_SECRET: - the name of the secret containing the keystore file
:JGROUPS_ENCRYPT_KEYSTORE: - the name of the keystore file within the secret
:JGROUPS_ENCRYPT_NAME: - the name or alias of the kesytore entry containing the server certificate
:JGROUPS_ENCRYPT_PASSWORD: - the password for the keystore and certificate
:JGROUPS_PING_PROTOCOL: - JGroups protocol to use for node discovery. Can be either openshift.DNS_PING or openshift.KUBE_PING.
:JGROUPS_CLUSTER_PASSWORD: -JGroups cluster password
//Ports
:PORT_5000: the port for the NodeJS HTTP Service on images that serve JavaScript applications
:PORT_8080: the port for the HTTP service hosted by JEE Servleit Containers on images that host Java services
:PORT_8443: the port for  the HTTPS service hosted by JEE Servlet Containers that support HTTPS. (P.S. generally we prefer to configure HTTPS on a router such as the Openshift Router)
:PORT_8778: the port for the Jolokia service on JBoss. This service is used primarily for monitoring.
:PORT_8888: the port that a ping service will expose to on support JGroups on images that support JGroups such as the JBoss EAP images

** **PORTDB_DATABASE** - {PORTDB_DATABASE}
** **PORTDB_USERNAME** - {PORTDB_USERNAME}
** **PORTDB_PASSWORD** - {PORTDB_PASSWORD}
** **SERVDB_DATABASE** - {SERVDB_DATABASE}
** **SERVDB_USERNAME** - {SERVDB_USERNAME}
** **SERVDB_PASSWORD** - {SERVDB_PASSWORD}
** **ADMIN_USERNAME** - {ADMIN_USERNAME}
** **ADMIN_PASSWORD** - {ADMIN_PASSWORD}
````