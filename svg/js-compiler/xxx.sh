#!/bin/bash
cd ../lisp-parts
./deliver.sh
cd ..
make clean
make
cd js-compiler
make newbp
echo
head temp6a.lisp
echo
ls -l temp6a*
