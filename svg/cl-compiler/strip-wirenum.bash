#!/bin/bash
sed -e 's/wireNum/WIRENUM/g' | sed -e '/WIRENUM/s/,.*$//g'

