#!/bin/bash
sed -e 's/(//g' -e 's/ /,/g' | sed -e 's/,/(/' | sed -e 's/ /(/' -e 's/)$/)./g'
