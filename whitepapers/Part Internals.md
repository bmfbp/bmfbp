Title: Part Internals  
Author: Paul Tarvydas

Internally, a Part consists of:

* list of input pin names
* list of output pin names
* an input queue
* an output queue
* a busy flag / status
* local state variables.

The Dispatcher invokes[^fn1] parts that are “ready”.[^fn2]

The invoked part must execute a reaction to the event, then return, as soon as possible, to the Dispatcher.  This means that all Parts do not use looping or recursion.

Parts react much like state machines.  Loops are created by sending feedback events to the same part.  A part must not execute long-running loops nor deep recursion in its “react” function.

Local state variables persist between invocations of the part.  Local variables are visible only to the parent part.  Local variables cannot be shared with other parts[^fn3]


[^fn1]: Calls the “react” function with the first event from the local input queue.

[^fn2]: Ready means that the part has at least one event on its input queue.

[^fn3]: Other than sending their immutable values in events.