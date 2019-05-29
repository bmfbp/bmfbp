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
	cat temp22.js

tee:
	jsbmfbp test_diagrams/tee.svg

top:
	jsbmfbp test_diagrams/top_level.svg

pass:
	jsbmfbp test_diagrams/pass_and_add.svg
