#!/bin/bash
cd ../lisp-parts
./deliver.sh
cd ../js-compiler
make clean
make
make test
echo
head temp6a.lisp
echo
ls -l temp6a*
