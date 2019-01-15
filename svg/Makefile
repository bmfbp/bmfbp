all:
	cd runtime && make
	cd svg-parser && make
	cd parts && make
	cd compiler && make

clean:
	cd runtime && make clean
	cd compiler && make clean
	cd parts && make clean
	cd svg-parser && make clean

test : 
	cd compiler && make test
