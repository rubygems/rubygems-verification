#!/usr/bin/env sh

cat rubygems-md5 | xargs -P 100 -n 2 ./validate_md5s3.sh
