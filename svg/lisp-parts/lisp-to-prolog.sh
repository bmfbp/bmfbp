#!/bin/bash
sed -e 's/^(//g' | sed -e 's/ /,/g' | sed -e 's/,/(/' | sed -e 's/)$/)./'
