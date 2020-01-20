Title: Pin  
Author: Paul Tarvydas

A pin[^fn1] is a tuple:

* name
* parent.

Name is a string or a positive integer[^fn2].

Parent is a reference to the part that owns the pin.  The pin is local to the parent part.

Pins are classified as 

* input pins
* output pins.

The names in the input pin namespace are distinct.[^fn3]  Likewise, all names in the output pin namespace are distinct.

The input and output namespaces are distinct from one another, so a part can have the same pin name in its input pin list as appears on its output pin list.


[^fn1]: a.k.a. port.

[^fn2]: An index.

[^fn3]: i.e. each name/index can appear only once in the namespace.