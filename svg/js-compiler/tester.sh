#!/bin/bash
NAME=$(basename $1 .svg)

# scanner
hs_vsh_drawio_to_fb <$1 >temp1.lisp
lib_insert_part_name $NAME <temp1.lisp >temp2.lisp
fb_to_prolog $NAME <temp2.lisp >temp3.pro
sort <temp3.pro >temp4.pro
check_input $NAME <temp4.pro >temp5.pro


calc_bounds $NAME <temp5.pro >temp6.pro
find_comments $NAME <temp6.pro >temp6a.pro

# rest of parser
add_kinds $NAME <temp6a.pro >temp7.pro
add_selfPorts $NAME <temp7.pro >temp7a.pro
make_unknown_port_names $NAME <temp7a.pro >temp8.pro
create_centers $NAME <temp8.pro >temp9.pro
calculate_distances $NAME <temp9.pro >temp10.pro
assign_portnames $NAME <temp10.pro >temp11.pro
markIndexedPorts $NAME <temp11.pro >temp12.pro
coincidentPorts $NAME <temp12.pro >temp13.pro
mark_directions $NAME <temp13.pro >temp14.pro
match_ports_to_components $NAME <temp14.pro >temp15.pro

# semantics
sem_partsHaveSomePorts <temp15.pro >temp16.pro
sem_allPortsHaveAnIndex <temp16.pro >temp17.pro

# emitter
assign_wire_numbers_to_inputs $NAME <temp17.pro >temp18.pro
assign_wire_numbers_to_outputs $NAME <temp18.pro >temp19.pro
assign_portIndices $NAME <temp19.pro >temp20.pro
emit_js $NAME <temp20.pro >temp21a.lisp
unmap-strings $NAME <temp21a.lisp >temp21.lisp
emit_js2 $NAME <temp21.lisp >temp22.js



