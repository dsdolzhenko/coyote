#!/usr/bin/env bash

set -e

# shellcheck disable=SC1091
. "${BASH_SOURCE%/*}"/config.sh

"${COYOTE_TARGET}"-gdb -q -se kernel/kernel.bin
