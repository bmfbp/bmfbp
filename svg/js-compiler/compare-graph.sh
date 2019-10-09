#!/bin/sh
echo
if diff -q $1 $2
then echo OK
else echo BAD
fi
echo
