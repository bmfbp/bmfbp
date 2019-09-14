BINDIR=~/bin
TEST_CASES=../../test_cases
BUILD_PROCESS=../../build_process

all: dependencies
# depends on the parts being built
# and on jsbmfbp.sh

dependencies:
	cd ../parts && make
	cp ./jsbmfbp.sh $(BINDIR)/jsbmfbp
	chmod a+x $(BINDIR)/jsbmfbp
	cp ./jsbmfbp2.sh $(BINDIR)/jsbmfbp2
	chmod a+x $(BINDIR)/jsbmfbp2
	cp ./part_compile.sh $(BINDIR)/part_compile
	chmod a+x $(BINDIR)/part_compile
	cp ./compare-graph.sh $(BINDIR)/compare-graph
	chmod a+x $(BINDIR)/compare-graph

clean:
	rm -f temp*.pro temp*.js temp*.lisp $(BINDIR)/jsbmfbp* $(BINDIR)/compare-graph temp.log*.txt strings.sed $(BINDIR)/part_compile
	rm -f $(BINDIR)/lisp-to-prolog $(BINDIR)/prolog-to-lisp

test: dependencies
	jsbmfbp $(TEST_CASES)/firstTests/js_test_emitter.svg
	compare-graph temp28.json graph-out.js

test2:
	jsbmfbp $(TEST_CASES)/firstTests/js_test2_emitter.svg

test3:
	jsbmfbp $(TEST_CASES)/firstTests/js_test3_emitter.svg

test4:
	jsbmfbp $(TEST_CASES)/firstTests/js_test4_emitter.svg

test5:
	jsbmfbp $(TEST_CASES)/firstTests/js_test5_emitter.svg

test6:
	jsbmfbp $(TEST_CASES)/firstTests/js_test6_emitter.svg

xx:
	cd ../ && make 
	make test6
	cat temp.log.txt

tee:
	jsbmfbp $(TEST_CASES)/composites/tee.svg
	compare-graph temp28.json tee_regression.js

top:
	jsbmfbp $(TEST_CASES)/composites/top_level.svg
	compare-graph temp28.json top_regression.js

pass:
	jsbmfbp $(TEST_CASES)/composites/pass_and_add.svg
	compare-graph temp28.json pass_and_add_regression.js

pass2:
	jsbmfbp2 $(TEST_CASES)/composites/pass_and_add.svg
	compare-graph temp28.json pass_and_add_regression.js

ide:
	jsbmfbp $(BUILD_PROCESS)/kk/ide.svg

bp:
	jsbmfbp $(BUILD_PROCESS)/kk/build_process.svg

junk:
	jsbmfbp $(BUILD_PROCESS)/kk/junk.svg

comp:
	jsbmfbp $(BUILD_PROCESS)/kk/compile_composites.svg


newbp:
	./new-jsbmfbp.sh $(BUILD_PROCESS)/kk/build_process.svg
