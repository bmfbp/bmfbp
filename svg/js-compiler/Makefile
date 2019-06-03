BINDIR=~/bin

all: dependencies
# depends on the parts being built
# and on jsbmfbp.sh

dependencies:
	cd ../parts && make
	cp ./jsbmfbp.sh $(BINDIR)/jsbmfbp
	chmod a+x $(BINDIR)/jsbmfbp
	cp ./compare-graph.sh $(BINDIR)/compare-graph
	chmod a+x $(BINDIR)/compare-graph

clean:
	rm -f temp*.pro temp*.js temp*.lisp $(BINDIR)/jsbmfbp $(BINDIR)/compare-graph

test: dependencies
	jsbmfbp test_diagrams/js_test_emitter.svg
	compare-graph temp22.js graph-out.js

test2:
	jsbmfbp test_diagrams/js_test2_emitter.svg
	compare-graph temp22.js graph-out.js

tee:
	jsbmfbp test_diagrams/tee.svg

top:
	jsbmfbp test_diagrams/top_level.svg

pass:
	jsbmfbp test_diagrams/pass_and_add.svg
