#!/bin/bash
grep 'defmethod' v2mechanisms.lisp >temp1
sed -e 's/(defmethod /(trace--/' <temp1 >temp2
sed -e 's/ .*$/)/' <temp2 >temp3
sed -e 's/trace--/trace /' <temp3 >temp4
