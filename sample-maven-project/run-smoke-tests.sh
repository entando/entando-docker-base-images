#!/usr/bin/env bash
#Initialization
APPLICATION_NAME="sample-maven-project"
JEE_SERVER=${1:-eap}
DBMS=${2:-mysql}

echo "Running smoke tests for ${APPLICATION_NAME} using $JEE_SERVER and $DBMS"

#pre-test cleanup
mvn -P${JEE_SERVER} -P${DBMS} -DskipDocker=false docker:stop 2>/dev/null
docker volume rm ${APPLICATION_NAME}-entando-data ${APPLICATION_NAME}-entando-db-data 2>/dev/null

#run full tests
mvn clean package -P${JEE_SERVER} -P${DBMS} docker:start -Doracle.repo.user=${ORACLE_REPO_USER} \
        -Doracle.repo.password=${ORACLE_REPO_PASSWORD} || { echo "Maven build failed"; exit 1; }
#mvn -P${JEE_SERVER} -P${DBMS} docker:start || { echo "Maven build failed"; exit 1; }
docker run --rm --network=${APPLICATION_NAME}-network \
    -e ENTANDO_APPBUILDER_URL=http://appbuilder:5000  \
    entando/entando-smoke-tests:5.2.0-SNAPSHOT mvn verify -Dtest=org.entando.selenium.smoketests.STAddTestUserTest \
    || { echo "AddTestUser smoke test failed"; exit 2; }
#mvn -P${JEE_SERVER} -P${DBMS} docker:stop || { echo "Stopping containers from Maven failed"; exit 3; }
#mvn -P${JEE_SERVER} -P${DBMS} docker:start  -Doracle.repo.user=${ORACLE_REPO_USER} && \
#        -Doracle.repo.password=${ORACLE_REPO_PASSWORD} || { echo "Restarting containers from Maven failed"; exit 4; }
docker run --rm --network=${APPLICATION_NAME}-network \
    -e ENTANDO_ENGINE_URL=http://${APPLICATION_NAME}-engine:8080/${APPLICATION_NAME} \
    -e ENTANDO_APPBUILDER_URL=http://appbuilder:5000  \
    entando/entando-smoke-tests:5.2.0-SNAPSHOT mvn verify -Dtest=org.entando.selenium.smoketests.STLoginWithTestUserTest \
    || { echo "LoginWithTestUser smoke test failed"; exit 5; }

#post-test cleanup
mvn -P${JEE_SERVER} -P${DBMS} docker:stop 2>/dev/null
docker volume rm ${APPLICATION_NAME}-entando-data ${APPLICATION_NAME}-entando-db-data 2>/dev/null
exit 0
