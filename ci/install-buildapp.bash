#!/usr/bin/env bash

dist_name=buildapp
dist_file=${dist_name}.tgz
dist_uri="http://www.xach.com/lisp/${dist_file}"
# FIXME derive from sed-ing the tar contents?
dist_version="1.5.6"

wget ${dist_uri}
tar xfvz ${dist_file}
pushd ${dist_name}-${dist_version} && ./configure && make && sudo make install
popd





