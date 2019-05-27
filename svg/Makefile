BINDIR=~/bin

all:
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
