Title: builder  
Author: Paul Tarvydas

# Introduction #

The Arrograms MVP consists of 4 parts:

- a drawing tool
- a diagram compiler
- a “builder” which builds a diagram and instantiates all components needed by the diagram and its sub-diagrams.
- a kernel that runs a built diagram.

In addition, we use a local directory to house the diagrams and leaf nodes (e.g. .JS files).  We are using git to manage the local directories and component versions.

## Drawing Tool ##

Currently, we are using Draw.IO.

We are building a new diagram editor using ELM.


## Compiler ##

The compiler takes a diagram as input and outputs a .JSON file.

Diagrams contain boxes and arrows and a manifest.

Such diagrams are called schematics (similar to schematics in electronics CAD).  In the future, we will have other kinds of diagrams (e.g. state machines).

A box represents a software component.  A component can be another schematic or a leaf node which contains code in some language.  At present, all leaf nodes contain JavaScript (.JS).

A box has a name (like a class-name, I call it a kind), one input queue, one output queue, a set of inputs and a set of outputs (e.g. an input api plus an output api).  Currently, on Draw.IO diagrams, inputs are signified by arrow-heads and outputs a signified by the starting-end (no arrowhead) of lines.

Each box on a diagram is uniquely instantiated before run time. If needed, the runtime gives each instance some kind of unique name/address (internal).  Such unique name(s) are not represented on the diagram.

Lines with arrows represent data flow paths between boxes.  I call such lines wires.  There is no other way to share data between boxes[^fn1].

Data travelling on a wire is called an event.  Events consist of a blob of data, e.g. a struct, a scalar, an object, etc, with a tag that signifies the input pin of the receiver or the output pin of the sender.[^fn2]

Events and wires are currently not typed.  Think of a 1/4” guitar cord plug that plugs into any 1/4” jack, regardless of whether the wire carries an audio signal or +-5V (or whatever).

Boxes are completely concurrent.  Ordering of event data cannot be known.

We do guarantee that an event output on a wire reaches all destination inputs “in the same order” (and appear in the input queues of all receivers “in the same order”).  Events on wires are atomic and not interruptible.[^fn3] 

In the least-efficient case, boxes can be implemented as O/S Processes[^fn4].  The system works like a bunch of communicating state machines,[^fn5] where an incoming event causes a state change[^fn6].  More cpu-efficient implementations can be constructed using closures, Duff’s devices, etc.[^fn7]

## Builder ##

The builder is given a top-level diagram, and does a tree-walk of all associated diagrams and sub-diagrams.

The Builder splits the diagram up into two portions:

1. The diagram portion.  The diagram is sent to the Compiler and compiled to .JSON.  The Compiler can ingest one diagram at a time.  It is the Builder’s responsibility to dissect the diagram and to pull out the diagram portion.
2. If any box on the diagram is another diagram (schematic), that diagram is fed back into the builder and dissected.

The Builder creates enough information for the Kernel to instantiate all the components.

The Builder and the Kernel can co-exist and we often think of the two being inseparable.  The Builder is “like” a linking loader and the Kernel is “like” a runtime.

## Kernel & Dispatcher ##

The Kernel and the Dispatcher constitute the runtime library of an Arrowgrams system.

The Kernel instantiates all components, wires them up[^fn8] and then it runs a dispatch loop.

The Dispatcher loop simply visits all components and CALLs any component which has anything in its input queue, i.e. is ready.  Once the CALLed component returns to the Dispatcher, the Dispatcher clears the output queue of the component and distributes the events to all receivers.

Guarantee:[^fn9] a schematic is busy[^fn10] if any of its children[^fn11] are busy.  Corollary: a schematic consumes no more input events until all children have finished processing.

[^fn1]: Well, cheating can be used, but is strongly discouraged.

[^fn2]: Note that “output pins” are converted to “input pins” during the act of sending the event on a wire.

[^fn3]: This matters if a wire splits from one output to multiple inputs in a multi-tasking environment.

[^fn4]: threads

[^fn5]: Full preemption is completely avoided.

[^fn6]: An event is processed to completion.  An event may linger for an unknown amount of time in an input queue, but once dequeued, the processing of the event must be done in a non-interruptible manner.

[^fn7]: None of the mentioned “more efficient” implementations provide memory management (MMUs) and, currently, the programmer is required to not share memory directly.

[^fn8]: According to the wiring specified on the original diagram(s).

[^fn9]: This guarantee might affect the dispatcher and any of its data structures (queues, stacks, etc.)

[^fn10]: Busy means non-dispatchable.  Not ready.

[^fn11]: Schematic nodes or Leaf nodes.