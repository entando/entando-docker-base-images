#!/usr/bin/env bash
pushd $(dirname "${BASH_SOURCE[0]}")/oracle-driver-installer
    ./install.sh || { echo "Could not install Oracle JDBC Driver"; exit 20; }
popd