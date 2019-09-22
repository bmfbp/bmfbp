current usage:

os> cd ??/bmfbp/svg/js-compiler
os> ./xxx
lisp> (load "??/bmfbp/svg/loadall.lisp")
lisp> (in-package :arrowgram)
lisp> (deb) ;; (for "debug")
os> cd ??/bmfbp/svg/js-compiler
os> ./new-jsbmfbp2.sh


I haven't figure out how to wire pload into this stuff yet.
I am using a "raw" clone of paip-lisp in ~/quicklisp/local-projects/paip-lisp.
...

Examine ??/bmfbp/svg/js-compiler/new-jsbmfbp2.sh to see the full pipeline as shell commands (most commands built as gprolog executable).  I'm slowly converting gprolog programs into lisp (with PAIP prolog) and moving the commented-out portions of new-jsbmfbp2.sh.

The original code built each piece as a gprolog executable.  Now the algorithm is debugged and known to work, the pipeline is being replaced by a series of sequential lisp function calls (in ??/bmfbp/svg/lisp-parts/lwpasses.lisp).