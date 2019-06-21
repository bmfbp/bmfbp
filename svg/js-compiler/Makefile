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
	rm -f temp*.pro temp*.js temp*.lisp $(BINDIR)/jsbmfbp $(BINDIR)/compare-graph temp.log*.txt

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
	cd .. && make
	make top

tee:
	./tester.sh $(TEST_CASES)/composites/tee.svg

top:
	./tester.sh $(TEST_CASES)/composites/top_level.svg

pass:
	./tester.sh $(TEST_CASES)/composites/pass_and_add.svg

aa:
	hs_vsh_drawio_to_fb <$(TEST_CASES)/firstTests/js_test_emitter.svg >temp001.lisp
	hs_vsh_drawio_to_fb <$(TEST_CASES)/firstTests/js_test2_emitter.svg >temp002.lisp
	hs_vsh_drawio_to_fb <$(TEST_CASES)/firstTests/js_test3_emitter.svg >temp003.lisp
	hs_vsh_drawio_to_fb <$(TEST_CASES)/firstTests/js_test4_emitter.svg >temp004.lisp
	hs_vsh_drawio_to_fb <$(TEST_CASES)/composites/tee.svg >temp005.lisp
	hs_vsh_drawio_to_fb <$(TEST_CASES)/composites/pass_and_add.svg >temp006.lisp
	hs_vsh_drawio_to_fb <$(TEST_CASES)/composites/top_level.svg >temp007.lisp

bb:
# problem with this one - generates no metadata -- because we need to use "kindName" instead of "name"
	hs_vsh_drawio_to_fb <$(TEST_CASES)/firstTests/meta4.svg >temp008.lisp
#	sed -f sed-temp1.sed <temp008.lisp >temp888.lisp

