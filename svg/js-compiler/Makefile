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
	compare-graph temp27.js graph-out.js

test2:
	jsbmfbp test_diagrams/js_test2_emitter.svg

test3:
	jsbmfbp test_diagrams/js_test3_emitter.svg

test4:
	jsbmfbp test_diagrams/js_test4_emitter.svg

xx:
	cd .. && make
	make top

tee:
	./tester.sh test_diagrams/tee.svg

top:
	./tester.sh test_diagrams/top_level.svg

pass:
	./tester.sh test_diagrams/pass_and_add.svg
