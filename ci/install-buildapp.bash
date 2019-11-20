#!/usr/bin/env bash

dist_name=buildapp
dist_file=${dist_name}.tgz
dist_uri="http://www.xach.com/lisp/${dist_file}"

wget ${dist_uri}
tar xfvz ${dist_file}
pushd ${dist_name} && ./configure && make && sudo make install
popd





