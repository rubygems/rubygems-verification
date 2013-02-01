#!/usr/bin/env sh

set -e

sum=$1
gem=$(basename $2)
dir=${gem/.gem/}

echo $gem
cd latest/$dir

if [[ "" = $((echo $1 $2; sha512sum ./$gem | awk '{print $1 " " $2}') | uniq -u) ]]; then
	echo $gem >> ../../valid_checksums.list
else
	echo $gem > ../../invalid_checksums.list
fi
