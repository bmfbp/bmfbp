#!/bin/bash
set -v

# scanner
#hs-vsh-drawio-to-fb test1 <test1.svg >temp1.lisp
#hs-vsh-drawio-to-fb test1 <test2.svg >temp1.lisp
#hs-vsh-drawio-to-fb test1 <test2a.svg >temp1.lisp
#hs-vsh-drawio-to-fb test1 <test3.svg >temp1.lisp
#hs-vsh-drawio-to-fb test1 <test4.svg >temp1.lisp
hs-vsh-drawio-to-fb test1 <test5.svg >temp1.lisp
lib_insert_part_name svgc <temp1.lisp >temp2.lisp
fb-to-prolog <temp2.lisp >temp3.pro
plsort <temp3.pro >temp4.pro
check_input <temp4.pro >temp5.pro

# parser
calc_bounds <temp5.pro >temp6.pro
add_kinds <temp6.pro >temp7.pro
make_unknown_port_names <temp7.pro >temp8.pro
create_centers <temp8.pro >temp9.pro
calculate_distances <temp9.pro >temp10.pro
assign_portnames <temp10.pro >temp11.pro
markIndexedPorts <temp11.pro >temp11a.pro
coincidentPorts <temp11a.pro >temp11b.pro
mark_directions <temp11b.pro >temp12.pro
match_ports_to_components <temp12.pro >temp13.pro

#semantic - empty
sem_partsHaveSomePorts <temp13.pro >temp13a.pro
sem_allPortsHaveAnIndex <temp13a.pro >temp13b.pro

# emitter
assign_wire_numbers_to_inputs <temp13b.pro >temp14.pro
assign_wire_numbers_to_outputs <temp14.pro >temp15.pro
assign_fds <temp15.pro >temp16a.pro
inOutPins <temp16a.pro >temp16.pro
plsort <temp16.pro >temp17.pro
emit-js <temp17.pro >temp18.lisp
emit-js2 <temp18.lisp >temp19.js
