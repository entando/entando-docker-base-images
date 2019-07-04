#!/usr/bin/env bash
if [ -n "${ORACLE_REPO_USER}" ] && [ -n "${ORACLE_REPO_PASSWORD}" ] ; then
    if ls /jetty-runner/ojdbc*.jar ; then
        echo "Oracle driver already  installed"
    else
        sed "s/ORACLE_REPO_USER/${ORACLE_REPO_USER}/g" settings-base.xml > settings.xml
        sed -i "s/ORACLE_REPO_PASSWORD/${ORACLE_REPO_PASSWORD}/g" settings.xml
        mvn clean package -s settings.xml -Doracle.maven.repo="${ORACLE_MAVEN_REPO:-https://maven.oracle.com}" || { echo "Could not download Oracle dependency"; exit 23; }
        if [ -n "${JBOSS_HOME}" ] ; then
            mkdir -p "${JBOSS_HOME}/modules/com/oracle/jdbc/main"
            cp module.xml "${JBOSS_HOME}/modules/com/oracle/jdbc/main/"
            cp *.jar "${JBOSS_HOME}/modules/com/oracle/jdbc/main/"
            DRIVER_XML="<driver name=\"oracle\" module=\"com.oracle.jdbc\"><driver-class>oracle.jdbc.driver.OracleDriver</driver-class></driver>"
            if [ -f "${JBOSS_HOME}/standalone/configuration/standalone-openshift.xml" ] ; then
                CONFIG_FILE="${JBOSS_HOME}/standalone/configuration/standalone-openshift.xml"
            else
                CONFIG_FILE="${JBOSS_HOME}/standalone/configuration/standalone.xml"
            fi
            sed -i "s|<!-- ##ORACLE_DRIVER## -->|${DRIVER_XML}|" ${CONFIG_FILE} || { echo "Could not setup Oracle driver in Wildfly"; exit 24; }
        fi
  #TODO tomcat
        cp *.jar "/jetty-runner/" || { echo "Could not setup Oracle driver in Jetty"; exit 25; }
    fi
fi
