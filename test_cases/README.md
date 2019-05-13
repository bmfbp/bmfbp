# Test cases

This directory contains schematics, code for leaves, and documentation to
comprehensively test the bmfbp system.

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
3. An output pin can be attached to zero or more input pins via wires.
    1. Zero pin
    2. One pin
    3. Many pins
4. An input pin can be attached to zero or more output pins via wires.
    1. Zero pin
    2. One pin
    3. Many pins
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
10. A source can be attached to zero or more input pins.
    1. Zero pin
    2. One pin
    3. Many pins
11. A sink can be attached to zero or more output pins.
    1. Zero pin
    2. One pin
    3. Many pins
