The Makefile creates the compiler and runs regression tests.

To simply USE the created compiler, run ../make first (which builds the parts in ../parts/) then run the jsbmfbp.sh script, with one argument - the name of an SVG file.  Note that the jsbmfbp.sh script is copied to ~/bin/jsbmfbp and chmod'ed to be executable (which is deleted by "make clean").

For example:

~/bin/jsbmfbp ../../test_cases/composites/top_level.svg


To use the part:

~/bin/part_compile ../../test_cases/composites/top_level.svg

which has a single output to stdout

-----

if unmapping .pro files, replace all \ with \\ in unmap-sed.sed, and use:

sed -f unmap-sed.sed <temp14.pro >xx14.pro
