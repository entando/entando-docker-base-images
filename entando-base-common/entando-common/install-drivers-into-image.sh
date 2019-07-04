#!/usr/bin/env bash
# This script is intended to be invoked from Maven to ship the proprietary drivers with the image
 $(dirname "${BASH_SOURCE[0]}")/install-proprietary-drivers.sh
 $(dirname "${BASH_SOURCE[0]}")/save-build-id.sh