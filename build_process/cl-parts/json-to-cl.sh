sed -e 's/{/(hashmap/g' -e 's/}/)/g' -e 's/,//g' -e 's/://g' -e 's/\[/#(/g' -e 's/\]/\)/g' $1

