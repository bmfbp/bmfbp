Title: Cloning  
Author: Paul Tarvydas

Events are never cloned.

They are passed as references and are read-only by the receivers.

Receivers must copy[^fn1] events if they need to mutate them.

The Dispatcher performs a shallow copy of events when dealing with fan-out[^fn2].  It clones the event cell, changes the output pin name to a local input pin of the receiver and places a reference to the data in the data field of the event[^fn3].

An orthogonal aspect of cloning appears when we consider putting parts into a “binary” repository.  It must be possible to use the same component multiple times[^fn4].  During the bootstrapping process, we clone parts using source inclusion.  Binary inclusion[^fn5] implies that we only know the external representation of a part[^fn6].  The “binary” representation of a part must include enough information to instantiate the part uniquely many times.

This aspect requires further discussion.

[^fn1]: a.k.a. clone

[^fn2]: Delivering an event to multiple receivers.

[^fn3]: i.e. without deep copying of the data.

[^fn4]: i.e. to instantiate a part multiple times in the same schematic.

[^fn5]: a.k.a. not knowing how the part is constructed.

[^fn6]: See “Part Externals” whitepaper.