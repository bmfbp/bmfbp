#!/bin/bash
NAME=$(basename $1 .svg)

# scanner
hs_vsh_drawio_to_fb <$1 >temp1.lisp
lib_insert_part_name $NAME <temp1.lisp >temp2.lisp
fb_to_prolog $NAME <temp2.lisp >temp3.pro
sort <temp3.pro >temp4.pro
check_input $NAME <temp4.pro >temp5.pro

# parser
find_comments $NAME <temp5.pro >temp6.pro
calc_bounds $NAME <temp6.pro >temp7.pro
add_kinds $NAME <temp7.pro >temp8.pro
add_selfPorts $NAME <temp8.pro >temp9.pro
make_unknown_port_names $NAME <temp9.pro >temp10.pro
create_centers $NAME <temp10.pro >temp11.pro
calculate_distances $NAME <temp11.pro >temp12.pro
assign_portnames $NAME <temp12.pro >temp13.pro
markIndexedPorts $NAME <temp13.pro >temp14.pro
coincidentPorts $NAME <temp14.pro >temp15.pro
mark_directions $NAME <temp15.pro >temp16.pro
match_ports_to_components <temp16.pro >temp17.pro

# semantics
sem_partsHaveSomePorts <temp17.pro >temp18.pro
sem_allPortsHaveAnIndex <temp18.pro >temp19.pro

# emitter
assign_wire_numbers_to_inputs $NAME <temp19.pro >temp20.pro
assign_wire_numbers_to_outputs $NAME <temp20.pro >temp21.pro
assign_portIndices $NAME <temp21.pro >temp22.pro
inOutPins <temp22.pro >temp23.pro
emit_js $NAME <temp23.pro >temp24.lisp
unmap-strings $NAME <temp24.lisp >temp25.lisp
emit_js2 $NAME <temp25.lisp >temp26.js


