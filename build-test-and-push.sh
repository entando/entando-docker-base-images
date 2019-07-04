#!/usr/bin/env bash
#Approach followed:
#We fail and halt the entire build if one of the docker builds failed, or pushing the images failed. These are serious problems that need to be fixed, as one image could depend on another.
#We don't halt the build if one of the tests failed, but we do push the images of tests that succeeded. We do fail the build though.
export VERSION=${1:-5.2.0-SNAPSHOT}
pushd entando-base-common
./build.sh ${VERSION} || { echo "Exiting build for entando-base-common because of result code $?"; exit 1; }
popd

IMAGES_IN_SEQUENCE=$(cat IMAGES_IN_SEQUENCE)
FAILED_TESTS=
for D in ${IMAGES_IN_SEQUENCE[@]}; do
    pushd $D
    echo "########## Building $D ###########"
    ./build.sh ${VERSION} || { echo "Exiting build for $D because of result code $?"; exit 1; }
    popd
done
for D in ${IMAGES_IN_SEQUENCE[@]}; do
    pushd $D
    echo "########## Testing $D ###########"
    if ./test.sh ${VERSION} > "${D}-test.log" ; then
        echo "Test for $D succeeded, pushing to Docker Hub"
        docker push entando/$D:${VERSION} || exit 1
    else
        FAILED_TESTS="${FAILED_TESTS} ${D}"
        echo "Test for $D failed, not pushing to Docker Hub"
    fi
    popd
done
if [ -z "${FAILED_TESTS}" ] ; then
    docker push entando/entando-base-common:${VERSION} || exit 1
    echo "Build succeeded. All images pushed successfully"
else
    echo "Please inspect the build logs. The following builds failed: ${FAILED_TESTS}"
    exit 1
fi
