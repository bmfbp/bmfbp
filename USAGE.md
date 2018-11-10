   # executables are placed in BINDIR
   # ensure the BINDIR is on your PATH

0. # to make grash

$ cd vsh/grash
$ make

1. # to make and run sample using gprolog (gnu prolog)
   # this uses diagrams created by yEd

$ cd vsh/pl_vsh
$ ./grun
$ ./run
   
2. # to make and run svg vsh
   # this uses lisp to read the parsed svg file and convert it to prolog
   # this uses diagrams created by an SVG editor
   # run step 0 first

3. # to make and run sample using SBCL and buildapp
   # (make sure that buildapp and sbcl are installed, see docs/usage)
   # this uses diagrams created by yEd

$ make
   

