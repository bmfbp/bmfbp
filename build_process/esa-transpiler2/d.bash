#!/bin/bash
sort out.lisp >sorted.lisp
sort ../esa-transpiler/exprtypes.lisp >e.sorted.lisp
diff -w sorted.lisp e.sorted.lisp
