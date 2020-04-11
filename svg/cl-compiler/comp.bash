#!/bin/bash
set -x
sort output.prolog | ./stripfloats.bash | ./strip-wirenum.bash >output2.prolog
sort ../js-compiler/$1 >xxx
./stripfloats.bash <xxx | ./strip-wirenum.bash >temp.pro
rm -f xxx
diff -iu output2.prolog temp.pro
