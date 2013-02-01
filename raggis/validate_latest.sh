#!/usr/bin/env sh
url=https://gist.github.com/raw/4675540/72b8146c46412721c49d7e3d1036004622f7907c/gistfile1.txt

mkdir -p latest
cd latest

curl -s $url | xargs -P 20 -n 1 ../validate_from_url.sh
