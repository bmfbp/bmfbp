This directory implements the metadata splitter component, which is a shortened clone of the full compiler.

The Makefile creates the splitter and runs regression tests.

To simply USE the created Component, run ../make first (which builds the parts in ../parts/) then run the splitmeta.sh script, with one argument - the name of an SVG file.  Note that the splitmeta.sh script is copied to ~/bin/splitmeta and chmod'ed to be executable (which is deleted by "make clean").

For example:

~/bin/splitmeta ../../test_cases/composites/top_level.svg

To use the part:

~/bin/part_split ../../test_cases/composites/top_level.svg

which has a dsingle output to stdout

