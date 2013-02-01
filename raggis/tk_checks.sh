#!/usr/bin/env sh

set -e

nv=$1

cd $nv
md5sum ./$nv.gem >> ../../tk-md5
sha512sum ./$nv.gem >> ../../tk-shas

