#!/usr/bin/env sh

set -e

url=$1
gem=$(basename $1)

echo $gem

if [[ ! -f $gem ]]; then
	curl -s -o $gem $url
fi

if file $gem | grep HTML > /dev/null; then
	rm $gem
	echo Invalid: $gem
fi
