all:
	cd ../grash && make
	cd ../hs-vsh && make
	cd parts && make
	cd compiler && make

clean:
	cd ../grash && make clean
	cd compiler && make clean
	cd parts && make clean
	cd ../hs-vsh && make clean

test : 
	cd compiler && make test
