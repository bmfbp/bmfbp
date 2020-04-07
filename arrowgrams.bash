#!/bin/bash
sbcl --eval '(ql:quickload :arrowgrams/build)' --eval '(arrowgrams/build::arrowgrams)' --quit ~/quicklisp/local-projects/build_process/parts/diagram/helloworld.svg
