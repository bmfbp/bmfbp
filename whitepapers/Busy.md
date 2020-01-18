Title: Busy  
Author: Paul Tarvydas

Every Part is busy until while it is processing a (single) input event.

Determination of busy is straight-forward for leaf[^fn1] parts.  Leaf parts are invoked by call-return for each input event.  Leaf parts are always observed to be non-busy (using call/return, the leaf part is busy if it is reacting to an event).

Schematic[^fn2] parts, on the other hand, are busy if any of their children are busy.  This must be determined by a recursive call at runtime.

Busyness is also more interesting on bare metal and multi-core implementations, or anywhere that an interrupt can occur[^fn3].  In such cases, busy is kept as an explicit bit flag.  The driver software needs to query the busy flag and, if the receiving part is busy,  then the driver simply enqueues the incoming event onto the input queue of the part.  If the part is not busy, the event is enqueued and the dispatcher is started.

[^fn1]: a.k.a. code parts.

[^fn2]: a.k.a Composite parts.

[^fn3]: e.g. some hypothetical multi-threaded implementation.