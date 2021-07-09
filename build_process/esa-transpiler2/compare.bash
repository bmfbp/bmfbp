#!/bin/bash
sort _junk.lisp > _junk.out
sort ../esa-transpiler/exprtypes.lisp >_exprtypes.out
diff -w _junk.out _exprtypes.out

