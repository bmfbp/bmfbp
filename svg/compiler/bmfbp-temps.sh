#!/bin/bash
# script to run svg compiler in separate pieces leaving temp files
# for debugging
svg-to-lisp svg_compiler.svg >temp1.lisp
fb-to-prolog <temp1.lisp >temp1a.pro
boot_insert <temp1a.pro >temp2.pro
plsort <temp2.pro >temp3.pro
pl_check_input <temp3.pro >temp4.pro
pl_calc_bounds <temp4.pro >temp5.pro
boot_add_kinds <temp5.pro >temp6.pro
boot_make_unknown_port_names <temp6.pro >temp7.pro
boot_create_centers <temp7.pro >temp8.pro
boot_calculate_distances <temp8.pro >temp9.pro
boot_assign_portnames <temp9.pro >temp10.pro
pl_mark_directions <temp10.pro >temp11.pro
pl_match_ports_to_components <temp11.pro >temp12.pro
pl_assign_pipe_numbers_to_inputs <temp12.pro >temp13.pro
pl_assign_pipe_numbers_to_outputs <temp13.pro >temp14.pro
pl_assign_fds <temp14.pro >temp15.pro
pl_emit <temp15.pro >temp.gsh

