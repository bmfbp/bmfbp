#!/bin/bash
cd ..
make clean
make
cd lisp-parts
./deliver.sh
cd ../js-compiler
make newbp
echo
head temp6a.lisp
echo
ls -l temp6a*
