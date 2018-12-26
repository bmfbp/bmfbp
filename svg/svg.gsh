#name top.gsh
pipes 17
fork
  inPipe 6
  exec pl_emit
krof
fork
  inPipe 5
  outPipe 6
  exec plsort
krof
fork
  inPipe 16
  outPipe 5
  exec pl_assign_fds
krof
fork
  inPipe 4
  outPipe 16
  exec pl_assign_pipe_numbers_to_outputs
krof
fork
  inPipe 10
  outPipe 4
  exec pl_assign_pipe_numbers_to_inputs
krof
fork
  inPipe 9
  outPipe 10
  exec pl_match_ports_to_components
krof
fork
  inPipe 14
  outPipe 8
  exec svg_add_kinds
krof
fork
  inPipe 3
  outPipe 7
  exec fb-to-prolog
krof
fork
  inPipe 13
  outPipe 12
  exec plsort
krof
fork
  inPipe 12
  outPipe 11
  exec pl_check_input
krof
fork
  inPipe 2
  outPipe 9
  exec pl_mark_directions
krof
fork
  inPipe 1
  outPipe 2
  exec svg_assign_portnames
krof
fork
  inPipe 0
  outPipe 1
  exec svg_calculate_distances
krof
fork
  inPipe 15
  outPipe 0
  exec svg_create_centers
krof
fork
  inPipe 8
  outPipe 15
  exec svg_make_unknown_portnames
krof
fork
  inPipe 7
  outPipe 13
  exec svg_insert
krof
fork
  inPipe 11
  outPipe 14
  exec pl_calc_bounds
krof
fork
  outPipe 3
  exec1st svg-to-lisp
krof
