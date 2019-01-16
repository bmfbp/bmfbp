This subdirectory is the "final" / "main" directory for a linux-based bmfbp that uses SVG files as input.

To build:
> make clean
> make

To regression test:
> make clean
> make
> make test

To use:
> bmfbp [filename].svg >[grash output name].gsh
> grash [grash output name].gsh
