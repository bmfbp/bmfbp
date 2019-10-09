BINDIR=~/bin

all: build test test2 test3 test4 tee pass top

build: 
	cd ../grash && make
	cd ../hs-vsh && make
	cd parts && make
	cd lisp-parts && make all
	cd flat-compiler && make
	cd js-compiler && make
	cd split && make

clean: 
	cd ../grash && make clean
	cd flat-compiler && make clean
	cd js-compiler && make clean
	cd split && make clean
	cd parts && make clean
	cd lisp-parts && make clean
	cd ../hs-vsh && make clean

test : 
	cd flat-compiler && make test
	cd js-compiler && make test

test2 : 
	cd js-compiler && make test2

test3 : 
	cd js-compiler && make test3

test4 : 
	cd js-compiler && make test4

test5 : 
	cd js-compiler && make test5

test6 : 
	cd js-compiler && make test6

tee:
	cd js-compiler && make tee

top:
	cd js-compiler && make top

pass:
	cd js-compiler && make pass

