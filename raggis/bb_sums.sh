#!/usr/bin/env sh

cd bb

ls | xargs -P 50 -n 1 ../bb_checks.sh
