#!/usr/bin/env sh

set -e

mkdir -p bb
cd bb

if [[ ! -f specs.4.8.gz ]]; then
	curl -s -o specs.4.8.gz http://production.cf.rubygems.org/specs.4.8.gz
fi

if [[ ! -f specs.4.8 ]]; then
	gzip -d specs.4.8
fi

if [[ ! -f specs.list ]]; then
	ruby -e "Marshal.load(File.read('specs.4.8')).map { |n, v, p| puts [n, v, p == 'ruby' ? nil : p].compact.join('-') }" > specs.list
fi

cat specs.list | xargs -P 150 -I% -n 1 ../validate_from_url.sh https://mirror01.c45627.blueboxgrid.com/gems/%.gem
