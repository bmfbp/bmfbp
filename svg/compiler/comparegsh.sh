#!/bin/bash
./normalizePipes.sh $1
./normalizePipes.sh $2
echo
if diff -q $1 $2
then echo OK
else echo BAD
fi
echo


       
