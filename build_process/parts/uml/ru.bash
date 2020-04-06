#!/bin/bash
fname=`basename $1 .uml`
plantuml ${fname}.uml
open ${fname}.png

