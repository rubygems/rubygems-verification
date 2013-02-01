#!/usr/bin/env sh

sum=$1
gem=$(basename $2)

echo $gem

if [[ $sum = $(curl -s -D - -X HEAD -H 'Connection:close' http://production.cf.rubygems.org/gems/$gem | grep ETag | cut -d '"' -f 2) ]]; then
	echo $gem >> valid_md5.list
else
	echo $gem >> invalid_md5.list
fi
