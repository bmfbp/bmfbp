BINDIR=~/bin

all: clean build test

build: 
	cd ../grash && make
	cd ../hs-vsh && make
	cd parts && make
	cd flat-compiler && make
	cd js-compiler && make

clean: 
	cd ../grash && make clean
	cd flat-compiler && make clean
	cd js-compiler && make clean
	cd parts && make clean
	cd ../hs-vsh && make clean

test : 
	cd flat-compiler && make test
	cd js-compiler && make test

test2 : 
	cd js-compiler && make test2

test3 : 
	cd js-compiler && make test3


