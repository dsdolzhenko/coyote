#!/usr/bin/env bash

set -e

# shellcheck source=config.sh
. "${BASH_SOURCE%/*}"/config.sh

export CC="${COYOTE_TARGET}"-gcc
export LD="${COYOTE_TARGET}"-ld

make -C kernel
