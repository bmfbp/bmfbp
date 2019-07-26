BINDIR=~/bin
TEST_CASES=../../test_cases

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
	rm -f temp*.pro temp*.js temp*.lisp $(BINDIR)/jsbmfbp $(BINDIR)/compare-graph temp.log*.txt strings.sed

test: dependencies
	jsbmfbp $(TEST_CASES)/firstTests/js_test_emitter.svg
	compare-graph temp28.js graph-out.js

test2:
	jsbmfbp $(TEST_CASES)/firstTests/js_test2_emitter.svg

test3:
	jsbmfbp $(TEST_CASES)/firstTests/js_test3_emitter.svg

test4:
	jsbmfbp $(TEST_CASES)/firstTests/js_test4_emitter.svg

xx:
	cd ../ && make 
	make top

tee:
	jsbmfbp $(TEST_CASES)/composites/tee.svg

top:
	jsbmfbp $(TEST_CASES)/composites/top_level.svg
	compare-graph temp28.js top_regression.js

pass:
	jsbmfbp $(TEST_CASES)/composites/pass_and_add.svg
	compare-graph temp28.js pass_and_add_regression.js
