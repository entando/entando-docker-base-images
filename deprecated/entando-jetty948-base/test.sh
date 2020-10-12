#!/usr/bin/env bash
cd ../sample-maven-project
./run-smoke-tests.sh jetty-container derby || exit 43