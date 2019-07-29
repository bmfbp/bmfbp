#!/bin/bash
NAME=$(basename $1 .svg)

# scanner
hs_vsh_drawio_to_fb <$1 >temp1.lisp
#sed -f sed-temp1.sed <temp0.lisp >temp1.lisp
lib_insert_part_name $NAME <temp1.lisp >temp2.lisp
fb_to_prolog $NAME <temp2.lisp >temp3.pro
sort <temp3.pro >temp4.pro
check_input $NAME <temp4.pro >temp5.pro

# parser
calc_bounds $NAME <temp5.pro >temp6.pro
find_comments $NAME <temp6.pro >temp7.pro
isolate_metadata $NAME <temp7.pro >temp9.pro
sed -E -f strings.sed <temp9.pro >temp10.txt

#grep -E 'metadata.id...,id(...)..' <temp8.pro >temp9.pro
#sed -E 's/metadata.id...,id(...)../\1/gp' <temp9.pro >temp10.pro

#sed -f strings.sed <temp8.pro >temp.txt
#cat temp.txt

