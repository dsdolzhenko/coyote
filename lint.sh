#!/usr/bin/env bash

set -e

shellcheck -a -o all ./*.sh ./toolchain/*.sh
