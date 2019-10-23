#!/bin/zsh
set -v
BUILD_PROCESS=../../build_process
DRAWING=${BUILD_PROCESS}/kk/build_process.svg
#NAME=$(basename $(FILE) .svg)
NAME=build_process

(cd ../ ; make clean)
(cd ../ ; make)
# scanner
hs_vsh_drawio_to_fb <${DRAWING} >temp1.lisp
lib_insert_part_name ${NAME} <temp1.lisp >temp2.lisp
fb_to_prolog ${NAME} <temp2.lisp >temp3.pro
sort <temp3.pro >temp4.pro

prolog-to-lisp <temp4.pro >temp.lisp
