#!/usr/bin/env bash
export VERSION=${1:-5.2.0}
IMAGES_IN_SEQUENCE=$(cat IMAGES_IN_SEQUENCE)
for D in ${IMAGES_IN_SEQUENCE[@]}; do
    pushd $D
    echo "########## Pushing $D ###########"
    docker push entando/$D:$VERSION || exit 1
    popd
done




