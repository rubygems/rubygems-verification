#!/usr/bin/env sh

set -e

url=$1
gem=$(basename $1)
dir=${gem/.gem/}

echo $gem

mkdir -p $dir
cd $dir

if [[ ! -f $gem ]]; then
	curl -s -o $gem $url
fi

if file $gem | grep HTML > /dev/null; then
	rm $gem
	echo Invalid: $gem
fi

# if [[ ! -f metadata.gz ]]; then
# 	tar xf $gem
# fi
# 
# if $(zgrep '!ruby' metadata.gz | grep -v 'Gem::'); then
# 	echo $gem >> ../../suspects.list
# else
# 	echo $gem >> ../../clean.list
# fi
