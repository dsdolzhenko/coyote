#!/usr/bin/env bash

set -e

# shellcheck source=config.sh
. "${BASH_SOURCE%/*}"/../config.sh

rm -rf "${COYOTE_TOOLCHAIN_PREFIX}"
