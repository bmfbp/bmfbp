Title: Arrowgrams is Types  
Author: Paul Tarvydas

Arrowgrams Parts are described by their set of inputs and their set of outputs.

Ultimately, inputs[^fn1] are typeless.  Anything can be plugged into Arrowgrams input/output pins.

Arrowgram parts are cascaded to create filter chains.

The filter chains ensure that a "correct type" of object is flowing through the connection which reach input pins.

Each input pin can be connected to a different filter chain.

Pattern matching is the staple technology of current type systems.

Pattern matching was explored in the 1970's[^fn2].  The ultimate form of pattern matching is called parsing.

Parsers are usually used to pattern match whole programs.  Programs can be considered to be types[^fn3].

Parsers can be used to pattern-match bits[^fn4] and to decide whether combinations of bits constitute "more interesting" types.

Parsing is done using trees or using pipelines.

It is my opinion that pipelines offer an easier way to divide and conquer the task(s) of pattern matching.  See the seminal paper by Cordy, Holt and Wortman,[^fn5] for a way to build parsers using pipelines.

Arrowgrams pipelines are not limited to a single chain of Parts.  Parts can have multiple inputs and multiple outputs.  Parts can send messages to themselves[^fn6].  Pattern matching - typing - can be arbitrarily complex.  Each pin can have a different set of Parts feeding it.[^fn7]


I argue that Arrowgrams is a superset of Haskell.

A Haskell type can be represented in a chain of Arrowgrams Parts.

Arrowgrams Parts can include the notion of time.  An object can be parsed differently depending on the history feeding the parser.

For example, a network protocol consists of packets.  The type of the packets can be described in many layers.  The first layer (an Arrowgram parser) consists of a header, a body, and a trailer.

Arrowgrams Parts can be snapped together like LEGO(r) blocks to form arbitrarily complex pattern-matching chains.


[^fn1]: and outputs

[^fn2]: Maybe earlier?

[^fn3]: albeit, very complicated types.

[^fn4]: into bytes, into words, into more interesting types.

[^fn5]: Start with https://en.wikipedia.org/wiki/S/SL_programming_language.  See also the source code to PT Pascal http://research.cs.queensu.ca/home/cordy/pub/downloads/ssl/

[^fn6]: This is not the same as recursion.

[^fn7]: A type-matching filter chain.