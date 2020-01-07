#!/bin/bash
set -x
sort output.prolog | ./stripfloats.bash >output2.prolog
sort ../js-compiler/$1 >xxx
./stripfloats.bash <xxx >temp.pro
diff -i output2.prolog temp.pro
