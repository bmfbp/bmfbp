#!/bin/bash
sed -e 's/Pipe.*$/Pipe/g' <$1 >temp
rm -f $1
mv temp $1
