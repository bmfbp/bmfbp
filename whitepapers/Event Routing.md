Title: Event Routing  
Author: Paul Tarvydas

Event routing is performed by the parent schematic.  

Always.  

This is in contrast to most programming languages,  where callers can refer to callees directly by name. CSP also supports direct naming of receivers.  

DLLs provide islands of indirection between callers and callees.  The Linker permanently fixes up these islands by supplying final addresses at link time.  

A schematic is, in a sense, a first-class linker - all input and all output events are shepherded through islands of indirection.  Fixups are performed at load-time.

The pervasive indirection provided by schematics is an aspect of decoupling and refactoring provided by schematics.  Schematics provide rapid reconfigurability of software architectures. 

Schematics are hierarchical - schematics can be composed of other parts.  The parts that make up a schematic can be leaf parts or other schematics or a mixture.

Schematics cannot know how a part is implemented[^fn1]



[^fn1]: i.e. if a part is a leaf (code) part or a schematic part.