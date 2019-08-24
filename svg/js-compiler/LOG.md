How to read the log.

After a run, e.g make test, the log is in the file temp.log.txt.

Example: make test runs jsbmfbp on $(TEST_CASES)/firstTests/js_test_emitter.svg (see the Makefile for further details)

and produces temp.log.txt:

 id374[assign_portIndices].1 wire(id380) wireNum(2) id369[emit].0
 id382[assign_wire_numbers_to_outputs].1 wire(id388) wireNum(1) id374[assign_portIndices].0
 id392[assign_wire_numbers_to_inputs].1 wire(id398) wireNum(0) id382[assign_wire_numbers_to_outputs].0

Disassembling line 1...
```
 id374[assign_portIndices].1 wire(id380) wireNum(2) id369[emit].0
 ^part ID (sending)
       ^kindName (class for part)
                           ^pin name (1)
                                  ^wire ID
                                                 ^wire index (0-based)
                                                    ^part ID (receiving)
                                                          ^kindName for receiver
                                                                 ^pin of receiver
```
In English, this says "part id374 sends from pin 1 on wire #2 to part id369 pin 0".

(This exact relationship can be seen on the diagram js_test_emitter.svg)

