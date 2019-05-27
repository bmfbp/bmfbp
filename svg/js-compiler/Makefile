BINDIR=~/bin

all: dependencies
# depends on the parts being built
# and on jsbmfbp.sh

dependencies:
	cd ../parts && make
	cp ./jsbmfbp.sh $(BINDIR)/jsbmfbp
	chmod a+x $(BINDIR)/jsbmfbp

clean:
	rm -f temp*.pro temp*.js temp*.lisp $(BINDIR)/jsbmfbp

test: dependencies
	jsbmfbp test_diagrams/js_test_emitter.svg
