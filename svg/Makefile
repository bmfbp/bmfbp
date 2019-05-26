BINDIR=~/bin

all:
	cd ../grash && make
	cd ../hs-vsh && make && mv $(BINDIR)/hs-vsh-drawio-to-fb $(BINDIR)/hs_vsh_drawio_to_fb
	cd parts && make
	cd compiler && make
	cd js-compiler && make

clean: clean-passes
	cd ../grash && make clean
	cd compiler && make clean
	cd js-compiler && make clean
	cd parts && make clean
	cd ../hs-vsh && make clean

test : 
	cd compiler && make test
#	cd compiler && make test-passes

# passes:
# 	cd compiler && make passes

clean-passes:
	cd compiler && make clean-passes

# test-passes:
#	cd compiler && make test-passes
