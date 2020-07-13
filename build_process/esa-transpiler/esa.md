overview:

An ESA is a box on the Arrowgrams diagram.  Different word, same thing.

Modern software languages tend to force one to tangle design with code.

In untangling design from code, I found roughly 4 phases of Arrowgrams design:

1. Definition (of the graph, of the tree)

2. Querying the nodes of the graph.  (Nodes are Parts).

3. Loader - create runnable data structures from the graph, instantiate Parts as tree nodes.

4. Runner - the kernel which runs the Dispatcher and routes events (aka messages).

=== strategy ===

A design is broken into three parts:

1. A description of the classes (actually prototypes).

2. A description of how to use classes - scripts.

3. An implementation of the above, in some language - mechanisms.

=== scripts ===

Scripts are a part of the Architecture.

Scripts can be automatically compiled.

	The programmer needs only to write code for methods, not scripts.
    
=== scripts ===

Scripts are, firstly, writable.  Each construct has an explicit "end <construct>".

Writable scripts use up a lot of screen real-estate.

A syntax checker finds all of the syntax errors and typos.  This is what happens in state-of-the-art compilers.

After that, we can collapse the scripts by removing "end <construct>" from the scripts and collapsing lines where reasonable.

This step produces a .script.readable file that should be more useful to maintainers.

The step .script.writable --> .script.readable has not been implemented yet and will be left until later.  In fact, the IDE / Editor might provide these two views, switching from writable to readable format.

=========== definition ============

A "kind" is a prototype - a class that must be augmented at runtime with enough information to build an Arrowgrams ESA (Encapsulated Software Asset).

An Arrowgrams application is a tree of ESA's.

An ESA comes into being by instantiating a Kind.  To instantiate a Kind, an ESA inherits from the Kind (in the usual OO manner), then calls the instantiate() routine to make a copy of the prototype.

I used the terms "part" and "ESA" interchangably.  A Part is an ESA.

Note that a Kind includes instance variables.  The mechanism for creating instance variables can be hidden behind the mechanisms of OO inheritance.  If an OO language is not used, then instance variables must be explicitly allocated (on the heap).

A netlist is a routing table.  Each element of a netlist is a Wire.  A Wire has one Source and multiple Destinations.  The Source is a part/pin-name that places Events onto the wire.  The Destinations are part/pin-names of parts that receive events placed on this wire.  All part names are local to the ESA.  All pin-names are valid within the given parts (valid in their Kinds).  A Source can be an output pin of a child part or an input pin of the parent ESA (called SELF).  A Destination is a part-pin pair.  An Destination can be the input pin of a child part or and output pin of SELF.  An input pin of SELF can also be wired directly to an output pin of SELF.  Any pin not involved in a Wire is said to be N.C. (No Connection).  Events sent to N.C. pins are ignored.  Events never come into an N.C. pin (because it is N.C.).


Kinds are built during the definition phase, using OO inheritance plus the following methods:

- definition/add-input-pin(name)
- definition/add-output-pin(name)

- add-part(name,OtherKind) - associates a part with some other Kind and a local name.  The name is unique within the Kind being defined and cannot leak out of the ESA (i.e. the Kind being defined is the "package" that contains and hides the name).

- definition/create-wire >> wire  - creates an empty wire

- definition/set-source(wire,local-part-name,pin-name-of-part) - set the source of the wire to be the given part/pin ; local-part-name is the name of a child (in which case the pin-name must be an output pin of the child) or SELF (in which case the pin name must be the input pin of SELF)

- definition/add-destination(wire,local-part-name,pin-name) - add the part/pin pair to the destinations of the Wire ; the part name can be that of a child (in which case the pin-name must be an input pin of the child) or it can be SELF (in which case the pin-name must be an output pin of SELF).

Wires are added to a Kind using:

- definition/add-wire(self,w) - adds the Wire w to SELF's netlist.


(in the future, we would also like to scope Kinds - associate a set of Kinds to a given layer - import?)

When using an OO language, we want to make a class for Code parts that inherits from esa-prototype-kind, then have specific parts inherit from that (while adding instance variables and methods "intially" and "react" in the usual OO manner).

Similarly, Schematics should inherit from esa-prototype-kind and provide no instance variables and shared behaviour for "initially" and "react" methods.


=========== load ============

The Load phase creates runtime parts from the definition(s).

Most of the required information is already present in the definition of the part.  We create only enough new information to allow the tree of parts to run, e.g. we instantiate all parts, recursively.

1. Each runtime part has exactly one input queue and exactly one output queue.

2. Each runtime part has one parent (a Schematic (aka Composite)).  The Top part of the tree has nil as its parent.

3. A local scope of named parts is created.  We create an instance for each part (using its Kind) and put the instance into the appropriate named slot.  For the bootstrap, we use a hashmap of name X instance.

4. For the bootstrap, we do not copy the netlist (wires, routing table), but interpret it during runtime.  It is easy to see that the parts in the routing table could be resolved once in a JIT-like manner during Load time (or during Runtime).  We want to see this work before we optimize it.

=========== Runtime ============

The runtime consists of a Dispatcher which loops and invokes ready parts (at random).

A part is ready if it has a non-empty input queue and the busy() method returns nil. (All Leaf (aka Code, aka parts with no children) are always not busy, whereas any Schematic (aka Composite, aka any part that contains children) is not busy only if ALL of its children are not busy (again, we calculate this recursively at Runtime, leaving optimizations for a later date).

When invoked, a Part reacts to exactly one input event and pops the event from its input queue.

When an invoked Part finishes, the Dispatcher is resumed (for now, we implement this as CALL/RETURN - the Dispatcher calls a Part, the Part RETURNs when it is done).

During invocation, a Part may call SEND() zero or more times.  SEND creates an output event and enqueues it on its output queue.  SENDs are "deferred" and are not immediately distributed.

Upon resumption, the Dispatcher first distributes all generated output events to the appropriate receivers (as defined by the netlist), then, starts at the beginning calling one ready part at random.  Note that parts may become ready as a result of SEND being called during invocation of some part, and, the Dispatcher must refresh its idea of which parts are ready after each invocation.

