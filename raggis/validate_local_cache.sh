#!/usr/bin/env sh

if ! which openssl > /dev/null; then
	echo Install openssl
	exit 1
fi

if ! which curl > /dev/null; then
	echo Install curl
	exit 1
fi

echo This will take a while...

for gem in $(locate \*.gem); do
	gemfile=$(basename $gem)

	local=$(openssl md5 $gem | awk '{print $2}')
	remote=$(curl -s -D - -X HEAD -H 'Connection:close' http://production.cf.rubygems.org/gems/$gemfile | grep 'ETag' | cut -d '"' -f 2)

	if [[ ! $local = $remote ]]; then
		echo $gemfile mismatch. local: $local, remote: $remote
	fi
done

echo All done.
