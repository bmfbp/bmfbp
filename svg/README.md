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

We use Draw.IO diagrams for this version.
Drawing conventions:

- Rectangles represent Parts.

- Text in rectangles represents the name ("class") of the Part.

- Connections between Parts are drawn with (one-arrowhead) arrows.  Drawing convention in Engineering is that such lines must follow a path that is a combination of horizontal and vertical segments (Draw.IO seems to draw it this way automatically).

- Names of pins are currently integers, starting at 0.

- Pin index 0 means stdin, 1 means stdout, 2 means stderr, 3.. have no further meaning.

- Draw.IO doesn't make arrowheads "touch" rectangles exactly.  We use a fudge factor of +-20 to treat arrowheads as "close enough" to the edge of rectangles.  Sometimes

- Warning: we don't understand this problem yet - Sometimes Draw.IO, in complex diagrams, makes it look like arrows touch rectangles, but the compiler doesn't see it that way.  Adding bends and making the arrows land on non-centered landing-points seems to help.  Hence, you might get errors on perfectly good looking diagrams.  If so, try moving the arrows to touch rectangles at non-center points.  See svgc.svg for a diagram that only compiles when some of the arrows are bent.

- Pins are automatically detected as being the start points and end points of arrows.

- Pin indices are pieces of text that are outside of the rectangle.  The "unused" text closest to a pin are considered to be the name (index) of the pin.
