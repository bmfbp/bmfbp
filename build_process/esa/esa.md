A "kind" is a prototype - a class that must be augmented at runtime with enough information to build an Arrowgrams ESA (Encapsulated Software Asset).

An Arrograms application is a tree of ESA's.

An ESA comes into being by instantiating a Kind.  To instantiate a Kind, an ESA inherits from the Kind (in the usual OO manner), then calls the instantiate() routine to make a copy of the prototype.

I used the terms "part" and "ESA" interchangably.  A Part is an ESA.

Note that a Kind includes instance variables.  The mechanism for creating instance variables can be hidden behind the mechanisms of OO inheritance.  If an OO language is not used, then instance variables must be explicitly allocated (on the heap).

A netlist is a routing table.  Each element of a netlist is a Wire.  A Wire has one Source and multiple Destinations.  The Source is a part/pin-name that places Events onto the wire.  The Destinations are part/pin-names of parts that receive events placed on this wire.  All part name are local to the ESA.  All pin-names are valid within the given parts (valid in their Kinds).  A Source can be an output pin of a child part or an input pin of the parent ESA (called SELF).  A Destination is a part-pin pair.  An Destination can be the input pin of a child part or and output pin of SELF.  An input pin of SELF can also be wired directly to an output pin of SELF.  Any pin not involved in a Wire is said to be N.C. (No Connection).  Events sent to N.C. pins are ignored.  Events never come into an N.C. pin (because it is N.C.).


Kinds are built during the definition phase, using OO inheritance plus the following methods:

- add-input-pin(name)
- add-output-pin(name)

- add-named-part(name,OtherKind) - associates a part with some other Kind and a local name.  The name is unique within the Kind being defined and cannot leak out of the ESA (i.e. the Kind being defined is that "package" that contains and hides the name).

- create-wire >> wire  - creates an empty wire

- set-source-to-wire(local-part-name,pin-name-of-part) - set the source of the wire to be the given part/pin ; local-part-name is the name of a child (in which case the pin-name must be an output pin of the child) or SELF (in which case the pin name must be the input pin of SELF)

- add-destination-to-wire(local-part-name,pin-name) - add the part/pin pair to the destinations of the Wire ; the part name can be that of a child (in which case the pin-name must be an input pin of the child) or it can be SELF (in which case the pin-name must be an output pin of SELF).

Wires are added to a Kind using:

- add-wire-to-kind(w) - adds the Wire w to SELF's netlist.
