#!/usr/bin/env sh

cd tk

ls | xargs -P 50 -n 1 ../tk_checks.sh
