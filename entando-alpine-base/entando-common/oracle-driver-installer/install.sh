#!/usr/bin/env bash
if [ -n "${ORACLE_REPO_USER}" ] && [ -n "${ORACLE_REPO_PASSWORD}" ] ; then
    if ls /app/libs/ojdbc*.jar ; then
        echo "Oracle driver already  installed"
    else
        sed "s/ORACLE_REPO_USER/${ORACLE_REPO_USER}/g" settings-base.xml > settings.xml
        sed -i "s/ORACLE_REPO_PASSWORD/${ORACLE_REPO_PASSWORD}/g" settings.xml
        mvn clean package -s settings.xml -Dmaven.repo.local=/app/.m2/repository  -Doracle.maven.repo="${ORACLE_MAVEN_REPO:-https://maven.oracle.com}" || { echo "Could not download Oracle dependency"; exit 23; }
        cp *.jar "/app/libs/" || { echo "Could not setup Oracle driver"; exit 26; }
    fi
fi
