#!/usr/bin/env sh

set -e

nv=$1

cd $nv
md5sum ./$nv.gem >> ../../bb-md5
sha512sum ./$nv.gem >> ../../bb-shas

