#!/bin/sh
sed -e 's/{\\"/xxBRACEQUOTExx/g' $1 | sed -e 's/{\\"/~/g' | sed -e 's/{/(hashmap/g' -e 's/}/)/g' -e 's/,//g' -e 's/://g' -e 's/\[/#(/g' -e 's/\]/\)/g' | sed -e 's/xxBRACEQUOTExx/{\\"/g' | sed -e 's/~/"/g'

