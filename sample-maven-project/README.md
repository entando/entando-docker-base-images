
# Entando Sample Maven Proejcts

This application provides a basic skeleton Entando with a configuration streamlined for both local development
as well as packaging in a Docker image. 

# Prerequisites

In order for you to experiment with this app on your local machine, you need the following software :

* Docker version 1.13 or higher
* Maven 3 or higher
* Java 8 or higher
* A Git client


# Downloading the App

## For the Git techie:
From your terminal, navigate to the folder you would like to clone this app to. The run the following command:

```git clone https://github.com/entando/entando-docker-base-images.git```

The Maven project will then be available at `./entando-docker-base-images/sample-maven-project`


# The Docker host

This Maven project makes extensive use of Docker. In order to get this Maven project to integrate 
with Docker as intended, you may need to specify the ip address where  your Docker daemon is running. 
In this document we generally pass that as the '-Ddocker.host.ip' JVM system property.
If you are running Docker directly on Linux, this is optional as the Maven plugin is configured 
to use your Docker network's default gateway running on 172.17.0.1. Alternatively, you could also use your machine's
ip address. Don't use 'localhost' as this creates confusion when accessed from Docker containers and the container
attempts to connect to itself.

Some installations of Docker runs the Docker services inside its own VM. This is usually the case in the following
environments:
1. Older Windows based Docker installations
2. Older Apple based Docker installtions
3. Minishift, a lightweight preconfigured VM hosting Openshift.
4. Minikube, a lightweight preconfigured VM hosting Kubernetes

In all of these cases, your Docker host would be the ip address of the VM in question.

If you do not wish to specify the '-Ddocker.host.ip' JVM system property with every Maven command you run, you could
also override that property in your Maven pom.xml file. Just remember to revert to the value that your build server
requires it to be before committing your code. Assuming your build server is a Linux environment, the correct value
would be 172.17.0.1


# Local development flow

For local development, we have included the Maven Jetty plugin that runs the Eclipse Jetty Java web server directly 
on your current project. In other words, it does NOT create a Docker container for any Java web server in this mode.
The advantage of doing development in this mode is that your changes to your web resources will reflect 
instantaneously, leveraging Jetty's 'hot-deploy'  feature. 

When running in this mode, you may also prefer to use the embedded Derby database as it is a bit faster starting 
up your app that way. The resulting Derby databases are hosted in ${basedir}/target/derby on your local 
file system. Since Jetty itself is also running locally, it will have direct access to these database files without
the complexity of Docker volumes.

To activate this configuration, run the following command (note that the docker.host.ip property is 
optional on Linux):

  `mvn  clean package -Pjetty-local -Pderby docker:start jetty:run -Ddocker.host.ip=<DOCKER-HOST>`

Notice that the first profile specified, 'jetty-local', configures your Java web server environment of choice, 
whereas the second profile,  'derby' configures your database of choice. This is the general pattern we 
followed throughout this Maven project.

The Maven lifecycle phase, 'package' compiles your classess and packages them with your dependencies and other 
resources in a WAR. This Maven project is also configured to build the necessary Docker images during the 'package' phase,
but more on that later. The Maven goal, 'docker:start' starts the prebuilt Entando AppBuilder image, 
and sets it up to point to the Entando Engine instance running locally in Jetty. This local instance is started 
up by the 'jetty:run' Maven goal.

After running this command, you would be able to access the AppBuilder at http://\<DOCKER-HOST\>:5000 where \<DOCKER-HOST\>
is the ip address where you Docker server is running, as explained earlier. You can access the Entando Engine at
http://localhost:8080/entando-pam-ap. If you have changed the Maven artifactId of this project, replace the the the last
segment of that URL, also referred to as the web context of the app, from 'entando-pam-app' to the artifactId you have
chosen. 

You can stop the Jetty server directly by typing <CTRL>-C. The AppBuilder container will however still be running in the
background. If you wish to stop this container, you can either kill it from your Docker commandline, or you could run

`mvn -DskipDocker docker:stop -Ddocker.host.ip=<<DOCKER-HOST>>`

Once you are happy with the state of your app, remember to backup the database locally using the database 
backup feature in the Entando Administration app. When running your app using this 'jetty-local' profile, 
those database backups will be stored locally under src/main/webapp/protected, where it will then be picked 
up by the Entando Docker images. 

If you wish to reset the Derby databases, please delete the folder target/derby after you have stopped the 
jetty server. This will result in entirely new Derby databases being created, either based on the 
initialization logic of the Entando plugins you have selected, or, when present, the last database backups 
you have made to src/main/webapp/protected.  

# Running the app in a production-ready server

If you want to run your app in an application server that you would like to use in production, you have a choice of 
using our JBoss EAP 7.1 base image or our Wildfly 12 base image. We also have a Jetty base image you can use, although
this may not be ideal for production deployments. When using one of these Java web servers, you would 
probably also want to use one of our production ready database images, such our MySQL or PostgreSQL images. Derby 
is still available, but the Derby databases would be embedded in the image hosting the Java web server, and would
not be packaged in a separate image. This may not be ideal for certain clustering requirements where a shared database
is required. 

You can select your combination of Java web server image and database management systems  by using the 
previously highlighted pattern of activating the relevant profiles. You would combine the profile configuring 
your Java web server and the profile configuring your DBMS. For example, if you wish to run 
JBoss EAP and PostgreSQL, run this command:

`mvn clean package -Peap -Ppostgresql docker:start -Ddocker.host.ip=<<DOCKER-HOST>>`

If you wish to run Wildfly 12 and MySQL 5.7, run this command:

`mvn clean package -Pwildfly -Pmysql docker:start -Ddocker.host.ip=<<DOCKER-HOST>>`

If you wish to run Jetty 09.4 in a Docker image, combined with an embedded Derby database, you can activate the 
'jetty-container' and 'derby' profiles. Note that we use the 'jetty-container' profile as opposed to the 
'jetty-clocal' profile. Since the Docker container will be starting Jetty, there is no need to run 
the local Maven Jetty plugin goal of jetty:run. You can just run the following command:

`mvn clean package -Pjetty-container -Pderby docker:start -Ddocker.host.ip=<<DOCKER-HOST>>`

You can also combine Wildfly and Derby, which can be useful for proofs of concept. However, combining JBoss EAP and Derby 
is not recommended as the JBoss EAP image is pre-configured for clustering, and Derby in embedded mode doesn't support
clustering. As long as neither the 'jetty-local' profile nor the 'derby' profiles are used, both the Java web server image 
and the DBMS image that are produced by this command can be used in a production environment. These should preferably
deployed to a container orchestration product such as Docker Swarm, Kubernetes or Openshift. Please consult our 
documentation at http://docs.entando.com/#_designing_your_pipeline_for_entando for further guidance on how to setup
your pipelines for Entando. 

NB!! Please note that, should you choose to use JBoss EAP in a production environment, you need to have the necessary 
subscription from RedHat. 

If you would like to list your new images from Docker, just run:

`docker images -f reference=entandosamples/*`

# Migrating from Maven projects generated by our Maven Archetypes

* Back your existing project up to a different folder. You may need to compare some settings later on. Alternatively, you
  could also create a branch for these modifications in your local Git repository:
    
    ```
     git branch new-conf
     git checkout new-conf
    ```
  
* Remove the following folders and the files they contain:

    * src/main/conf
    * src/main/filters
    * src/main/webapp/WEB-INF/conf

* Copy the  following files and folders from this project to the equivalent location in your existing project:

   * src/main/conf
   * src/main/jetty
   * src/main/webapp/WEB-INF/web.xml
   
* Modify the properties files in src/main/conf to fit your requirements

* If you made any modifications to your old web.xml, compare the new one in src/main/webapp/WEB-INF/web.xml to your old 
  one and apply the necessary changes. Alternatively you could also use your favorite Git compare tool to do this.
  Make sure that the resulting web.xml file has no filter property placeholders as these will no longer be resolved
   
* Modify the groupId and artifactId of in your Maven pom.xml file. If you have added any dependencies in your original
  pom.xml file, copy them across to the new one. If you have made any modifications to the Maven plugins, things may 
  unfortunately get quite complicated, as we have changed our plugin configuration significantly. Please make sure
  you understand all the settings before changing it. 
  
# Advanced options

Once you are comfortable using this Maven project to develop locally using Jetty, and you have played around with
some of the Docker combinations, you are now free to explore some more advanced and interesting options.

## Mapping services to known ports

When it comes to mapping Docker container ports to ports on the Docker host, the default behaviour of the 
Docker Maven Plugin is to find a port available in the ephemeral range (32768 to 61000) and map it to the container
port. This works very well for a build server where you typically do not know which ports are available.
However, if you would like to view your Docker containers on your
local machine, running `docker ps` each time to see which ports the various services are running on can be rather
cumbersome. If you would like to export each service to a know port, just activate the 'local-ports' profile. When
this profile is activated, the Maven Docker Plugin will use the ports specified in the properties defined in the
profile. Their defaults values are as follows:

* Java web server: 8080
* App Builder: 5000
* MySQL: 3306
*PostgreSQL: 5432

You are free to changes these properties to fit your needs.

## Using Jetty hot deploy with MySQL or PostgreSQL

If you would like to use MySQL or PostgreSQL as a database, you just need to combine the correct DBMS profile with
the 'jetty-local' profile. The following command will start the MySQL database to back Entando from Jetty
  
  `mvn  clean package -Pjetty-local -Pmysql docker:start jetty:run -Ddocker.host.ip=<<DOCKER-HOST>>`
  
This command will build a MySQL image with pre-built databases inside it. These databases will get copied across to
a Docker volume named '${project.artifactId}-entando-db-data' as the container starts up. Any subsequent changes will
be stored in that Docker volume. You would also be able to connect to your local MySQL instance by connecting to
<<DOCKER-HOST>>:3306/portdb using the credentials portdbuser:portdb123 and to
<<DOCKER-HOST>>:3306/servdb using the credentials servdbuser:servdb123. You can change the credentials for MySQL by
changing the Maven properties <portdb.username>:<portdb.password> and <servdb.username>:<servdb.password> in the MySQL
profile.

You can terminate Jetty directly from the console by typing <CTRL>-C. The MySQL container will however still be running.
If this is what you had in mind, then you can start Jetty the next time without the 'docker:start' goal. In order to 
be consistent, you should also bypass the 'package' lifecycle phase so as not to build a new database image. The following command
will simply start Jetty and connect it to your existing database container:

  `mvn  -Pjetty-local -Pmysql jetty:run -Ddocker.host.ip=<<DOCKER-HOST>>`

You can stop the MySQL container (and the AppBuilder container) by running:

    `mvn -DskipDocker=false docker:stop -Ddocker.host.ip=<<DOCKER-HOST>>`

This will remove the MySQL container, but the underlying databases will remain in tact in the '${project.artifactId}-entando-db-data'
volume. As mentioned before, every time you run the 'package' lifecycle, the database image will be rebuilt. This can take
a bit of time, and is only really required if the database structure changes, such as when you add or remove an Entando
plugin the modifies the database structure. So if rebuilding the database image is
not what you want, but you still need to start the database container, skip the clean and package phases entirely:

  `mvn  -Pjetty-local -Pmysql docker:start jetty:run -Ddocker.host.ip=<<DOCKER-HOST>>`

All of these rules and features also apply to the PostgreSQL image and the 'postgresql' profile, except that the 
default port for PostgreSQL changes to 5432. Please remember to delete the database volume if you wish to switch 
from MySQL  to PostgreSQL or vice versa. You need to do this from the Docker command line (where
{project.artifactId} is the artifactId you have chosen for your project, 'entando-pam-app' by default):

    `docker volume rm ${project.artifactId}-entando-db-data'
   
## Using EAP or Wildfly

In order to activate one of the JBoss based images, you can use either the 'eap' or the 'wildfly' profile in
the place of the Java web server profile, where we previously used 'jetty-local'


`mvn clean package -Peap -Ppostgresql docker:start -Ddocker.host.ip=<<DOCKER-HOST>>` 

The 'docker:start' goal starts the containers in the background and then terminates the Maven process. You can
terminate these Docker container running the following command:

`mvn -DskipDocker=false docker:stop`

It is important to understand that the 'eap' and 'wildfly' profiles were optimized for execution on a build server.
It is generally a bad idea to assume that certain ports are available on a build server. For this reason, these
profiles were configured to use the Docker Maven Plugin's dynamic port assignment capabilities. When of of these 
profiles is active, the Docker Maven Plugin will look for available ports on the Docker host and map the container
ports to the available ports. The following ports will be mapped dynamically from its container to the dynamically
selected port on the host:

* App Builder Container: 5000
* EAP/Wildfly Container: 8080
* MySQL container: 3306
* PostgreSQL container: 5432

If you execute one of these profiles as is, you would therefore have to go and look for these port mappings from
the Docker command line running 

     `docker ps`
     
The result will look something like this:

```
CONTAINER ID  IMAGE                                          COMMAND                  CREATED        STATUS        PORTS                                           NAMES
34038c73597f  entando/appbuilder:5.1.0-SNAPSHOT              "container-entrypoin…"   2 minutes ago  Up 2 minutes  8080/tcp, 172.17.0.1:32783->5000/tcp            confident_hertz
a9d36673728f  entandosamples/entando-pam-app:5.1.0-SNAPSHOT  "/bin/sh -c \"${STI_S…"  2 minutes ago  Up 2 minutes  8443/tcp, 8778/tcp, 172.17.0.1:32782->8080/tcp  entando-pam-app-engine
d897790cf3a3  entandosamples/entando-pam-app-db              "container-entrypoin…"   2 minutes ago  Up 2 minutes  172.17.0.1:32781->5432/tcp                      entando-pam-app-dbms
```     

Notice the dynamically allocated ports 32781, 32782 and 32783 for the DBMS, EAP and AppBuilder containers respectively. 
You will also notice a properties files generated to 'target/ports.propertes' containing the ports and the ip address
of the the Docker host, all matched to properties that are used from Maven. This can be useful if you wish to lookup
the dynamically allocated ports from a different process, such as the one running your integration tests.

This dynamic allocation of ports may not be the behaviour you are looking for when experimenting with the resulting 
containers on your local machine. If you would like for AppBuilder to run on port 50000 as expected, the Entando Engine
on port 8080 as expected, MySQL on port 3306 and PostgreSQL on port 5432, activate the 'local-ports' profile:

`mvn clean package -Peap -Ppostgresql -Plocal-ports docker:start -Ddocker.host.ip=<<DOCKER-HOST>>` 

You can now access all the services on the port you would be expecting them to be if you were doing local development
using the 'jetty-local' profile. When running with the fixed local ports option, you are now free to stop individual containers
directly using the Docker command line. This is particularly useful if you made changes that will affect the Entando
Engine, but you need to retain the existing database. You can stop and rebuild the Entando Engine as follows (where 
${project.artifactId refers to the artifactId you have chosen or 'entando-pam-app' by default):

```
docker stop ${project.artifactId}-engine
docker rm ${project.artifactId}-engine
mvn clean package -Peap -Ppostgresql -Plocal-ports -DskipDatabaseImage=true -DskipAppBuilderImage=true -DautoCreateNetwork=false docker:start -Ddocker.host.ip=<<DOCKER-HOST>>` 
```

In the last command, you will notice that this command skips the database and AppBuilder images. It also instructs the
Docker Maven plugin not to automatically remove and recreate the custom network, as the previously started AppBuilder
and database containers would still have active endpoints in the custom network.
 
## Creating your own profiles

You are also free to add your own profiles to the Maven pom. All of the Maven plugins in the pom have been parameterized
with Maven properties. The profiles simply turn certain features on and off, and populate certain variables to support
those features. Just copy the properties from the various profiles together in your own profile. Let's say you want
to do local development using Wildfly and PostgreSQL, and you always want them to start on known ports, simply aggregate
all the properties from the 'wildfly' 'postgresql' and 'local-ports' properties. You could even make this the 
default profile. Your resulting profile would look something like this:

```
        <profile>
            <id>my-wildfly</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <!--Image configuration -->
                <skipDocker>false</skipDocker>
                <skipAppBuilderImage>false</skipAppBuilderImage>
                
                <entando.engine.address>${docker.host.address}</entando.engine.address>
                <app.builder.depends.on>${project.artifactId}-engine</app.builder.depends.on>

                <skipServerImage>false</skipServerImage>
                <jboss.home.in.image>/wildfly</jboss.home.in.image>
                <server.base.image>entando-wildfly12-base</server.base.image>

                <derby.base.folder>/entando-data/databases</derby.base.folder>
                <skipDatabaseImage>false</skipDatabaseImage>
                <entando.engine.depends.on>${project.artifactId}-dbms</entando.engine.depends.on>
                <db.base.image>entando-postgresql95-base</db.base.image>
                <db.init.command>$STI_SCRIPTS_PATH/init-postgresql-from-war.sh  --war-file=/tmp/${project.build.finalName}.war --jetty-version=${jetty.version}
                </db.init.command>
                <db.volume.mount.path>/var/lib/pgsql/data</db.volume.mount.path>
                <db.server.port>5432</db.server.port>


                <portdb.database>portdb</portdb.database>
                <portdb.url>jdbc:postgresql://${docker.host.address}:${db.server.local.port}/${portdb.database}</portdb.url>
                <portdb.username>portdbuser</portdb.username>
                <portdb.password>portdb123</portdb.password>
                <portdb.jndi>java:/jdbc/portDataSource</portdb.jndi>
                <portdb.driverClassName>org.postgresql.Driver</portdb.driverClassName>

                <servdb.database>servdb</servdb.database>
                <servdb.url>jdbc:postgresql://${docker.host.address}:${db.server.local.port}/${servdb.database}</servdb.url>
                <servdb.username>servdbuser</servdb.username>
                <servdb.password>servdb123</servdb.password>
                <servdb.jndi>java:/jdbc/servDataSource</servdb.jndi>
                <servdb.driverClassName>org.postgresql.Driver</servdb.driverClassName>

                <!-- No DB work required from the server image. Just set the build_id -->
                <server.init.command>echo $(date +%s) > /entando-data-templates/build_id</server.init.command>

                <!--Hard coded ports for local development -->
                <appbuilder.port>5000</appbuilder.port>
                <db.server.local.port>${db.server.port}</db.server.local.port>
                <entando.engine.port>8080</entando.engine.port>
            </properties>
        </profile>

```

