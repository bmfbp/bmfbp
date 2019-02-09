#!/bin/bash
base1=`basename $1`
base2=`basename $2`
f1=/tmp/${base1}
f2=/tmp/${base2}
sed -e 's/Pipes.*$/Pipes/' $1 >${f1}
sed -e 's/Pipes.*$/Pipes/' $2 >${f2}
sleep 1
echo
if diff -q ${f1} ${f2}
then echo OK
else echo BAD
fi
echo
