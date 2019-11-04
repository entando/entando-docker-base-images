#!/usr/bin/env bash
export VERSION=${1:-6.0.0-SNAPSHOT}
IMAGES_IN_SEQUENCE=$(cat IMAGES_IN_SEQUENCE)
for D in ${IMAGES_IN_SEQUENCE[@]}; do
    pushd $D
    echo "########## Pushing $D ###########"
    docker push entando/$D:$VERSION || exit 1
    popd
done




