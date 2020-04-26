#!/bin/bash
#sbcl --eval '(ql:quickload :arrowgrams/build :silent nil)' --eval '(arrowgrams/build::arrowgrams)' --quit ~/arrowgrams/helloworldworld.svg
sbcl --eval '(ql:quickload :arrowgrams/build :silent nil)' --eval '(arrowgrams/build::arrowgrams)' --quit
