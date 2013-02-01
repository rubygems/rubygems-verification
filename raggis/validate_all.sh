#!/usr/bin/env sh

set -e

mkdir -p all
cd all

if [[ ! -f specs.4.8.gz ]]; then
	curl -s -o specs.4.8.gz http://production.cf.rubygems.org/specs.4.8.gz
fi

if [[ ! -f specs.4.8 ]]; then
	gzip -d specs.4.8
fi

if [[ ! -f specs.list ]]; then
	ruby -e "Marshal.load(File.read('specs.4.8')).map { |n, v, p| puts [n, v, p == 'ruby' ? nil : p].compact.join('-') }" > specs.list
fi

cat specs.list | xargs -P 20 -I% -n 1 ../validate_from_url.sh http://production.cf.rubygems.org/gems/%.gem
