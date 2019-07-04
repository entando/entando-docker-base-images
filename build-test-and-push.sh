#!/usr/bin/env bash
export VERSION=${1:-5.2.0-SNAPSHOT}
pushd entando-base-common
./build.sh ${VERSION} || { echo "Exiting build for entando-base-common because of result code $?"; exit 1; }
popd
IMAGES_IN_SEQUENCE=$(cat IMAGES_IN_SEQUENCE)
ENTANDO_BASE_COMMON_WORKS=true
for D in ${IMAGES_IN_SEQUENCE[@]}; do
    pushd $D
    echo "########## Building $D ###########"
    ./build.sh ${VERSION} || { echo "Exiting build for $D because of result code $?"; exit 1; }
    popd
done
for D in ${IMAGES_IN_SEQUENCE[@]}; do
    pushd $D
    echo "########## Testing $D ###########"
    if ./test.sh ${VERSION} ; then
        echo "Test for $D succeeded, pushing to Docker Hub"
        docker push entando/$D:${VERSION} || exit 1
    else
        ENTANDO_BASE_COMMON_WORKS=false
        echo "Test for $D failed, not pushing to Docker Hub"
    fi
    popd
done
if [ "${ENTANDO_BASE_COMMON_WORKS}" == "true" ] ; then
    docker push entando/entando-base-common:${VERSION} || exit 1
fi
