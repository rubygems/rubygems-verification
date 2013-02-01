#!/usr/bin/env sh
set -e

cat rubygems-shas | xargs -n 2 -P 20 ./validate_checksum.sh
