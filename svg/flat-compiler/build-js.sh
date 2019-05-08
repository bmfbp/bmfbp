#!/bin/bash
export BINDIR=~/bin
flatbmfbp js-passes.svg >${BINDIR}/js-passes.gsh
flatbmfbp pass-js-emit.svg >${BINDIR}/pass-js-emit.gsh
cp js-passes pass-js-emit ${BINDIR}
chmod a+x ${BINDIR}/js-passes ${BINDIR}/pass-js-emit
