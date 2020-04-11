See Diagram-Compiler-As-A-Compilable-Diagram.jpg first.

This is the second release, 0.2, of vsh (visual shell) and grash (graph
shell).

Presently, the code is in "alpha" / toy state, but is intended to
inspire and demonstrate some simple concepts for building FBP-like
(flow-based programming) visual tools using components implemented in
various languages.

This examplar implementation runs on linux and implements a (very)
simple replacement for "sh" that uses diagrams to represent
combinations of commands and pipes, based on the notions of FBP.
These ideas should be easily transcribeable onto other operating
systems. 

Concepts that may be of interest:

- implement FBP on top of linux, in place of bash and friends

- a multi-lingual FBP

- a trivial (250 lines of C) "graph" shell that could be used with
  other implementations of FBP to spawn concurrent components and
  plumb them together

- a simple technique for compiling diagrams to code

- use of an off-the-shelf diagram tool to produce compilable code

- the concept of factbases

- obvious future extensions to add sockets, named pipes, etc., as flow
  carriers 



See the docs directory for instructions and internal documentation.

See pl_vsh for Prolog version


## Layers of the bmfbp build system

1. IDE
2. Compiler
3. Design rule checker
4. Kernel

### Design rule checker

This checks that:

- A Part's shape matches with the specification in the repo pointed to by its
  location string (git repo + commit + entry path). e.g
  ["https://github.com/bmfbp/bmfbp", "/main.svg",
  "41c00f5211bc2202bc3daf37fe2d7ebcb5308d16"].

### IDE

Requirements:

- Run on a local machine on any platform (Windows/Mac/Linux).
- Fetch from any Git repo for a Component's definition given a universally recognizable address to identify a particular Component.
- Produce a JS file that could be run with Node.js.
- Store metadata on the schematic: schematic name and mappings from Part alias to Part location (URL + entry point path + commit).
- User is able to search for Components by keywords.
- User is able to publish Components.
- User is able to specify which commit of a Component to use.
- User is able to put comments on the diagram (represented by some shape other than a rectangle).
- Support for StateCharts
- IDE allows users to define templates for Part alias mappings.
- Aspects to address
- Fetching Components using Git

See initial discussion for context: https://github.com/bmfbp/bmfbp/issues/37


## Instructions

1. Download Docker at `https://www.docker.com/`.
2. Run `./build.sh ${programPath}` to build and run, where `programPath` is the
   path to the SVG file.
3. Repeat step 2 to rebuild after making a change.
