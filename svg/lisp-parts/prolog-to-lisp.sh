#!/bin/bash
sed -e 's/(/ /g' -e 's/)\./)/g' -e 's/,/ /g' -e 's/^/(/g' -e '/^($/d' -e 's/_/-/g' | tr "'" '"'
