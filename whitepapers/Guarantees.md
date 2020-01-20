Title: Guarantees  
Author: Paul Tarvydas

Arrowgrams guarantees that:

* Output events are sent in the order that they are created.
* An output event that fans-out[^fn1] is delivered atomically to all receivers, i.e. other events cannot appear on the input queues of receivers until the fanned-out event has been fully delivered to all receivers.

Arrowgrams does not guarantee:

* When output events are dispatched from one part.
* Ordering of execution of ready parts.
* Whether all outputs from one part are sent “at the same time” as other outputs from that part.  
1. example, if a part sends events A,B and C, then the dispatcher is free to to dispatch event A, “pause” and dispatch events from other parts, then dispatch B and C.  Arrowgrams only guarantees that C will follow B which follows A in time. 


[^fn1]: Is sent from one output pin to multiple input pins.