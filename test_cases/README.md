# Test cases

This directory contains schematics, code for leaves, and documentation to
comprehensively test the bmfbp system.

You can open all the composite diagrams using the file `all_diagrams.svg` in
Draw.IO.

The compiler is expected to produce something like the `output/executable.js`.
When run, it would produce the same output as `output/executable_output.txt`.
You can run the JS file by running `node output/executable.js`.

The JSON files in the `output/` are the expected output of the compiler for the
composites. For instance, `output/tee.json` is the JSON representation of
`composites/tee.svg`.

## Valid cases in a diagram

The test case schematics under the directory `composites` reference these
cases by its numeric index.

1. A kind can have zero or more input pins.
    1. Zero pin
    2. One pin
    3. Many pins
2. A kind can have zero or more output pins.
    1. Zero pin
    2. One pin
    3. Many pins
3. An output pin can be attached to zero or more wires.
    1. Zero wire
    2. One wire
    3. Many wires
4. An input pin can be attached to zero or more wires.
    1. Zero wire
    2. One wire
    3. Many wires
5. A kind can be either a leaf or a composite.
    1. Leaf
    2. Composite
6. There can be multiple parts of the same kind in a single schematic.
    1. One part
    2. Many parts
7. A composite can have zero or more sinks.
    1. Zero sink
    2. One sinks
    3. Many sinks
8. A composite can have zero or more sources.
    1. Zero source
    2. One sources
    3. Many sources
9. A composite contains zero or more kinds.
    1. Zero kind
    2. Many kind
10. A source can be attached to zero or more wires.
    1. Zero wire
    2. One wire
    3. Many wires
11. A sink can be attached to zero or more wires.
    1. Zero wire
    2. One wire
    3. Many wires
12. A wire can be attached to:
    1. Exactly one input pin and zero output pin
    2. Exactly one output pin and zero input pin
    3. Exactly one output pin and one input pin
