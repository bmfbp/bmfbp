#!/bin/bash
NAME=$(basename $1 .svg)

if grep -q "Not supported by viewer" $1 ; then
   echo "BAD svg (contains Not supported by viewer)"
   exit 1
fi

# scanner
hs_vsh_drawio_to_fb <$1 >temp1.lisp
lib_insert_part_name $NAME <temp1.lisp >temp2.lisp
fb_to_prolog $NAME <temp2.lisp >temp3.pro
sort <temp3.pro >temp4.pro
prolog-to-lisp <temp4.pro >temp5.lisp
