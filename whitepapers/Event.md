Title: Event  
Author: Paul Tarvydas

An Event[^fn1] is a 2-tuple:

* a pin name
* data.

Events can be classified as input events and output events.

At all times, the pin name refers to a pin name local to the part.  The dispatcher converts output pin names of the sender to local pin names of the receiver.[^fn2]

For events on the input queue of a part, pin names refer to local input pins of the receiving part.

For events on the output queue of a part, pin names refer to local output pins of the sending part.

[^fn1]: a.k.a. message.

[^fn2]: In fan-out situations, where one output pin sends events to multiple receivers, the Dispatcher must create new events (shallow copy) and convert the output pin names to match input pin names of each of the receivers.