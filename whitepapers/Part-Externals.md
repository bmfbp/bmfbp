Title: Parts  
Author: Paul Tarvydas

From an external perspctive, a Part[^fn1], at its most basic, is  4-tuple

* List of inputs
* List of outputs
* reaction function
* first-time function[^fn2]

Using OO techniques, we can reduce this to a 3-tuple:

* List of inputs
* List of outputs
* Kind

Where Kind[^fn3] is

* reaction function
* first-time function

A Schematic[^fn4] Part also contains a parts list and a wiring list, so a Schematic is a 6-tuple:

* List of inputs
* List of outputs
* reaction function
* first-time function
* parts list
* wiring list.

Using OO, this cannot be reduced further, since each schematic might contain a different initialization function (e.g. to initialize constants inside the schematic).

* List of inputs
* List of outputs
* Kind (schematic)
* first-time function
* parts list
* wiring list.

All Schematics share the same reaction function.

N.B. the wiring list belongs to the Schematic and is “interpreted” by the Schematic.  That means that, semantically, all parts[^fn5] defer event delivery to their parent schematics.  Parts cannot[^fn6] refer directly to other parts - event routing is performed by parent schematics.

N.B. during bootstrapping, we might choose not to implement each field for all kinds of Parts.

[^fn1]: a.k.a. Component

[^fn2]: A.k.a. Initialization

[^fn3]: Very similar to “Class”

[^fn4]: a.k.a. Composite

[^fn5]: Leaf or schematic.

[^fn6]: Must not.