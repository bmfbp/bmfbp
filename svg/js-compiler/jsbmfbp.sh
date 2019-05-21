#!/bin/bash
NAME=$(basename $1 .svg)

# scanner
hs-vsh-drawio-to-fb $NAME <$1 >temp1.pro
lib_insert_part_NAME $NAME <temp1.pro >temp2.pro
fb_to_prolog $NAME <temp2.pro >temp3.pro
sort <temp3.pro >temp4.pro
check_input $NAME <temp4.pro >temp5.pro

# parser
calc_bounds $NAME <temp5.pro >temp6.pro
add_kinds $NAME <temp6.pro >temp7.pro
make_unknown_port_NAMEs $NAME <temp7.pro >temp8.pro
create_centers $NAME <temp8.pro >temp9.pro
calculate_distances $NAME <temp9.pro >temp10.pro
assign_portNAMEs $NAME <temp10.pro >temp11.pro
markIndexedPorts $NAME <temp11.pro >temp12.pro
coincidentPorts $NAME <temp12.pro >temp13.pro
mark_directions $NAME <temp13.pro >temp14.pro
match_ports_to_components <temp14.pro >temp15.pro

# semantics
sem_partsHaveSomePorts <temp15.pro >temp16.pro
sem_allPortsHaveAnIndex <temp16.pro >temp17.pro

# emitter
assign_wire_numbers_to_inputs $NAME <temp17.pro >temp18.pro
assign_wire_numbers_to_outputs $NAME <temp18.pro >temp19.pro
assign_portIndices $NAME <temp19.pro >temp20.pro
emit_js $NAME <temp20.pro >temp21.lisp
emit_js2 $NAME <temp21.lisp >temp22.js


