#!/bin/bash
set -v

# scanner
scanner svgc <svgc.svg >temp30.pro

# parser
parser svgc <temp30.pro >temp31.pro

#semantic - empty
semantic <temp31.pro >temp32.pro

# emitter
emitter <temp32.pro >temp33.pro
