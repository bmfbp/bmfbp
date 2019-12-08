#!/bin/bash
jsbmfbp3 "$@"
[ $? -gt 0 ] && >&2 echo "jsbmfbp failed" && exit 3
cat temp28.json
