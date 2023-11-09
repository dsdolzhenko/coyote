#!/usr/bin/env bash

set -e

# shellcheck disable=SC1091
. "${BASH_SOURCE%/*}"/build.sh

rm -rf iso_root
mkdir -p iso_root/boot/grub
cp grub.cfg iso_root/boot/grub
cp kernel/kernel.bin iso_root/boot
grub-mkrescue -o "${COYOTE_ISO_IMAGE}" iso_root
rm -rf iso_root
