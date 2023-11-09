#!/usr/bin/env bash

set -e

# shellcheck disable=SC1091
. "${BASH_SOURCE%/*}"/iso.sh

qemu-system-"${COYOTE_ARCH}" -M q35 -m 2G -no-reboot -no-shutdown \
                             -cdrom "${COYOTE_ISO_IMAGE}" -boot d "$@"
