#!/bin/bash
set -v

# scanner
#hs-vsh-drawio-to-fb test1 <test1.svg >temp1.lisp
#hs-vsh-drawio-to-fb test1 <test2.svg >temp1.lisp
#hs-vsh-drawio-to-fb test1 <test2a.svg >temp1.lisp
#hs-vsh-drawio-to-fb test1 <test3.svg >temp1.lisp
#hs-vsh-drawio-to-fb test1 <test4.svg >temp1.lisp
hs-vsh-drawio-to-fb test1 <test11.svg >temp1.lisp
lib_insert_part_name svgc <temp1.lisp >temp2.lisp
fb-to-prolog <temp2.lisp >temp3.pro
plsort <temp3.pro >temp4.pro
check_input <temp4.pro >temp5.pro

# parser
calc_bounds <temp5.pro >temp6.pro
add_kinds <temp6.pro >temp6a.pro
add_selfPorts <temp6a.pro >temp7.pro
