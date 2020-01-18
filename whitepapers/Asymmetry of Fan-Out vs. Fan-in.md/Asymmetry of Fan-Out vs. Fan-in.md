Title: Asymmetry of Fan-Out vs. Fan-in  
Author: Paul Tarvydas

Fan-out occurs when an output pin sends events to more than one receiver.

Fan-in occurs when multiple events arrive at a receiver from multiple pins.

See the “Guarantees” white paper.

When events are sent in a fan-out operation, the event send must be done atomically, i.e. all receivers must be locked, then the event copied to their input queues, then all receivers are unlocked.[^fn1]

Fan-in does not require this consideration[^fn2].

This fan-out vs. Fan-in asymmetry is reflected in the wiring lists of Arrowgrams.  A wire must include all of the receivers for a given output pin.  

For example, consider Fig. 1

![][Example1]
Fig. 1 Example 1

The wiring list might be expressed as
A.u —> [C.w, D.y]
B.v —> [C.x, D.z]
E.q —> G.s
F.r —> G.s




[Example1]: Example1.png width=207px height=223px

[^fn1]: This applies to event-sending on bare metal and probably does not apply to Arrowgrams implemented on top of synchronous (call-return) languages and operating systems.  Dispatch based on call-return performs implicit locking and does not need to be performed explicitly.

[^fn2]: Since every event is sent atomically, events coming in from different pins will always be dispatched at different times.