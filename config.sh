#!/usr/bin/env bash

set -e

export COYOTE_ARCH=x86_64
export COYOTE_TARGET=${COYOTE_ARCH}-elf
COYOTE_TOOLCHAIN_PREFIX="$(realpath "${BASH_SOURCE%/*}")"/toolchain/root
export COYOTE_TOOLCHAIN_PREFIX

export PATH=${COYOTE_TOOLCHAIN_PREFIX}/bin:${PATH}
