#!/usr/bin/env bash

set -e

# shellcheck source=config.sh
. "${BASH_SOURCE%/*}"/config.sh

make -C kernel clean
