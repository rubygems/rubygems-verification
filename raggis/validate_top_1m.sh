#!/usr/bin/env sh

url=https://gist.github.com/raw/4675642/398f4d86c44381b4557050aa05018b7e15fe3b10/gistfile1.txt

mkdir -p top1m
cd top1m

curl -s $url | xargs -P 20 -n 1 ../validate_from_url.sh
