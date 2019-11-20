#!/usr/bin/env bash


dist_name=gprolog-1.4.5
dist_file=${dist_name}.tar.gz
dist_uri=http://gprolog.org/${dist_file}

wget ${dist_uri}

tar xfvz ${dist_file}
pushd ${dist_name}
pushd src && ./configure && make && make install
popd
popd

