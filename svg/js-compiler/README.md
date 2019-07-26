The Makefile creates the compiler and runs regression tests.

To simply USE the created compiler, run ../make first (which builds the parts in ../parts/) then run the jsbmfbp.sh script, with one argument - the name of an SVG file.  Note that the jsbmfbp.sh script is copied to ~/bin/jsbmfbp and chmod'ed to be executable.

For example:

~/bin/jsbmfbp ../../test_cases/composites/pass_and_add.svg