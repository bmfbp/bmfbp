Title: Wires Source and Receivers  
Author: Paul Tarvydas

A wire is a tuple:

* a source,[^fn1]
* list of input receivers.[^fn2]

For example, consider Fig. 1

![][Example1]
Fig. 1 Example 1

This example contains 4 wires.

The wiring list might be expressed as

A.u —> [C.w, D.y]
B.v —> [C.x, D.z]
E.q —> G.s
F.r —> G.s

The sources are A.u, A.b, E.q and F.r.

The receivers are C.w, C.x, D.y, D.z and G.s.

In this example, the first wire has A.u as its source and the list [C.w,D.y] as its list of receivers.

Wires belong to schematics[^fn3].

A source consists of

* an output pin (which also includes a reference to the sending part)
* a wire, a list of receivers.

A receiver consists of

* an input pin (which also includes a reference to the receiving part).



[Example1]: Example1.png width=207px height=223px

[^fn1]: Basically an output pin and an output part, see below

[^fn2]: parts/pins - see below

[^fn3]: Event routing is performed by the parent schematic.  Alway.  This is in contrast to most programming languages,  where callers can refer to callees directly by name.  This also occurs in CSP.  DLLs provide islands of indirection between callers and calles.  The Linker permanently fixes up these islands by supplying final addresses at link time.  A schematic is, in a sense, a first-class linker - all input and all output events are shepherded through islands of indirection.  Fixups are performed at load-time.