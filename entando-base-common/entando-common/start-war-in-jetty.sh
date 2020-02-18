#!/usr/bin/env bash
source $(dirname ${BASH_SOURCE[0]})/build-jetty-command.sh "$@"
$JETTY_COMMAND
