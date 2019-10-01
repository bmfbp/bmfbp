#!/bin/bash
# stdout gets the original file (going to compiler) ($1 -> stdout)
# stderr gets the metadata string (going to IDE) (temp10.txt -> stderr)

# copy file to stdout
cat $1

splitmeta $1 2>/dev/null
# copy file to stderr
cat temp10.txt >&2
