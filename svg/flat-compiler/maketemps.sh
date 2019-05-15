#!/bin/bash
set -v
hs_vsh_drawio_to_fb svgc <svgc.svg >temp1.lisp
lib_insert_part_name svgc <temp1.lisp >temp2.lisp
fb_to_prolog <temp2.lisp >temp3.pro
plsort <temp3.pro >temp4.pro
check_input <temp4.pro >temp5.pro
calc_bounds <temp5.pro >temp6.pro
add_kinds <temp6.pro >temp7.pro
make_unknown_port_names <temp7.pro >temp8.pro
create_centers <temp8.pro >temp9.pro
calculate_distances <temp9.pro >temp10.pro
assign_portnames <temp10.pro >temp11.pro
mark_directions <temp11.pro >temp12.pro
match_ports_to_components <temp12.pro >temp13a.pro
sem_partsHaveSomePorts <temp13a.pro >temp13.pro
assign_wire_numbers_to_inputs <temp13.pro >temp14.pro
assign_wire_numbers_to_outputs <temp14.pro >temp15.pro
assign_portIndices <temp15.pro >temp16.pro
plsort <temp16.pro >temp17.pro
emit <temp17.pro >temp18.gsh
