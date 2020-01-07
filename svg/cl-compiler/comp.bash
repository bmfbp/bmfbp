#!/bin/bash
sort output.prolog | ./stripfloats.bash >output2.prolog
sort ../js-compiler/$(1) | ./stripfloats.bash >temp.pro
diff -i output2.prolog temp.pro
