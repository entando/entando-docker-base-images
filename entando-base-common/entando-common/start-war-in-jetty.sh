#!/usr/bin/env bash
${ENTANDO_COMMON_PATH}/install-proprietary-drivers.sh
source $(dirname ${BASH_SOURCE[0]})/build-jetty-command.sh "$@"
$JETTY_COMMAND
