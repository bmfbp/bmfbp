# usage:
# linux: svgpasses <name> > <outfile>


BINDIR=~/bin
SVG_DIAGRAM=svgc.svg
REGRESSION=regression.gsh
PASSES-REGRESSION=passes-regression.gsh

all: linux-based-compiler build-js

linux-based-compiler: dependencies passes
# the linux-based compiler is used to compile the compiler for compiling js (build-js)

build-js : linux-based-compiler
	./build-js.sh

run-js: build-js
	./run-js.sh

svgpasses : dependencies ./build-svgpasses
	./build-svg

dependencies:
	mkdir -p $(BINDIR)
	cp bmfbp.sh $(BINDIR)/bmfbp
	cp flatbmfbp.sh $(BINDIR)/flatbmfbp
	chmod a+x $(BINDIR)/bmfbp
	chmod a+x $(BINDIR)/flatbmfbp
	cp svg.gsh $(BINDIR)

clean: clean-temps clean-passes clean-dependencies clean-js
	rm -f $(BINDIR)/bmfbp $(BINDIR)/svg.gsh $(REGRESSION) $(BINDIR)/flatbmfbp

clean-dependencies:
	rm -rf ${BINDIR}/bmfbp ${BINDIR}/flatbmfbp ${BINDIR}/svg.gsh ${BINDIR}/comparegsh.sh

clean-temps:
	rm -f *.pro
	rm -f temp1.lisp temp18.lisp temp19.js

test : dependencies
	flatbmfbp $(SVG_DIAGRAM) >$(REGRESSION)
	sleep 1
	cp $(BINDIR)/svg.gsh ./temp.gsh
	comparegsh.sh temp.gsh $(REGRESSION)

passes : passes-linux passes-js

passes-linux :
	flatbmfbp passes.svg >$(BINDIR)/svgpasses.gsh
	flatbmfbp scanner.svg >$(BINDIR)/scanner.gsh
	flatbmfbp parser.svg >$(BINDIR)/parser.gsh
	flatbmfbp semantics.svg >$(BINDIR)/semantics.gsh
	flatbmfbp emitter.svg >$(BINDIR)/emitter.gsh
	cp svgpasses scanner parser semantics emitter unity comparegsh.sh $(BINDIR)
	chmod a+x $(BINDIR)/svgpasses $(BINDIR)/unity $(BINDIR)/scanner $(BINDIR)/parser \
		$(BINDIR)/semantics $(BINDIR)/emitter $(BINDIR)/comparegsh.sh

passes-js :
	./build-js.sh

test-passes: passes
# semantics is contained only in svgpasses version
	flatbmfbp $(SVG_DIAGRAM) >$(REGRESSION)
	grash ${BINDIR}/svgpasses.gsh svgc < ${SVG_DIAGRAM} >${PASSES-REGRESSION}
	$(BINDIR)/comparegsh.sh $(PASSES-REGRESSION) $(REGRESSION)
	sleep 1
	flatbmfbp passes.svg >$(REGRESSION)
	grash ${BINDIR}/svgpasses.gsh passes <passes.svg >${PASSES-REGRESSION}
	$(BINDIR)/comparegsh.sh $(PASSES-REGRESSION) $(REGRESSION)

clean-passes :
	rm -f $(BINDIR)/svgpasses* $(BINDIR)/scanner.gsh \
		$(BINDIR)/parser.gsh $(BINDIR)/emitter.gsh ${BINDIR}/unity
	rm -f $(BINDIR)/semantics* $(BINDIR)/scanner $(BINDIR)/parser \
		$(BINDIR)/emitter ${BINDIR}/js-emitter \
		${BINDIR}/svgjspasses*
	rm -f $(PASSES-REGRESSION)

clean-js:
	rm -f ${BINDIR}/js-emitter ${BINDIR}/js-passes* ${BINDIR}/pass-js-emit*
	rm -f temp.js

