#!/bin/sh
./json-to-cl.sh ide.json >ide-network.lisp
./json-to-cl.sh build_process.json >build-process-network.lisp
./json-to-cl.sh compile_composites.json >compile-composites-network.lisp
