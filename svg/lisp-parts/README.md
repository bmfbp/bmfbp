(update: working up to assign-parents-to-ellipses)

current usage:

os> cd ??/bmfbp/svg/js-compiler
os> ./xxx
lisp> (load "??/bmfbp/svg/lisp-parts/loadall.lisp")
lisp> (in-package :arrowgram)
lisp> (deb) ;; (for "debug")
os> cd ??/bmfbp/svg/js-compiler
os> ./new-jsbmfbp2.sh


I haven't figure out how to wire pload into this stuff yet.
I am using a "raw" clone of paip-lisp in ~/quicklisp/local-projects/paip-lisp.
...

Examine ??/bmfbp/svg/js-compiler/new-jsbmfbp2.sh to see the full pipeline as shell commands (most commands built as gprolog executable).  I'm slowly converting gprolog programs into lisp (with PAIP prolog) and moving the commented-out portions of new-jsbmfbp2.sh.

The original code built each piece as a gprolog executable.  Now the algorithm is debugged and known to work, the pipeline is being replaced by a series of sequential lisp function calls (in ??/bmfbp/svg/lisp-parts/lwpasses.lisp).

The original compiler wrote temp files, instead of using pipes, to the I could check progress.

The new compiler writes a tempfile, then converts it from lisp to prolog (lisp-to-prolog) and continues the "pipeline" to completion to check the everything still works.

The shell script does a regression test, comparing results against saved files, and prints OK on success.  Currently, all such regression tests fail and print BAD.  I find that there is no point in creating new snapshots until I've converted the whole pipeline from gprolog to lisp.

For example, the current output goes to ??/bmfbp/svg/js-compiler/lisp-out.lisp, gets munged by lisp-to-prolog and becomes temp7.pro.

For now, the input and output files are hard-wired into lwpasses.lisp.  Once everything works, we'll switch to using the code in lwpasses.lisp/main() and use *standard-input* and *standard-output* again. Note that SBCL expects a different form for main() than does LW.

## Dependencies

### loops

Try <https://github.com/guitarvydas/loops>.

## Testing

Using PROVE, so for the first time for every installation, one must
issue a

    (ql:quickload :arrowgram-test)

then to run the simple test

    (prove:run-all :arrowgram-test)

