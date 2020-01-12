#!/bin/bash
set -x
sort output.prolog | ./stripfloats.bash >output2.prolog
sort ../js-compiler/$1 >xxx
./stripfloats.bash <xxx >temp.pro
rm -f xxx
diff -iu output2.prolog temp.pro
