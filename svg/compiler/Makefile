# usage:
# linux: svgpasses <name> > <outfile>


BINDIR=~/bin
SVG_DIAGRAM=svgc.svg
REGRESSION=regression.gsh
PASSES-REGRESSION=passes-regression.gsh

all: dependencies js

js :
	./build-js.sh
	./run-js.sh

dependencies:
	mkdir -p $(BINDIR)
	cp bmfbp.sh $(BINDIR)/bmfbp
	cp flatbmfbp.sh $(BINDIR)/flatbmfbp
	chmod a+x $(BINDIR)/bmfbp
	chmod a+x $(BINDIR)/flatbmfbp
	cp svg.gsh $(BINDIR)

clean: clean-temps clean-passes clean-dependencies
	rm -f $(BINDIR)/bmfbp $(BINDIR)/svg.gsh $(REGRESSION) $(BINDIR)/flatbmfbp
	rm -f ${BINDIR}/pass-js-emit.gsh
	rm -f ${BINDIR}/pass-js-emit

clean-temps:
	rm -f *.pro
	rm -f temp1.lisp temp18.lisp temp19.js

clean-dependencies:
	rm -f ${BINDIR}/bmfbp.sh
	rm -f ${BINDIR}/flatbmfbp.sh
	rm -f ${BINDIR}/svg.gsh
	rm -f ${BINDIR}/comparegsh.sh

test : dependencies
	flatbmfbp $(SVG_DIAGRAM) >$(REGRESSION)
	sleep 1
	cp $(BINDIR)/svg.gsh ./temp.gsh
	comparegsh.sh temp.gsh $(REGRESSION)

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
	rm -f $(BINDIR)/svgpasses.gsh $(BINDIR)/scanner.gsh \
		$(BINDIR)/parser.gsh $(BINDIR)/emitter.gsh ${BINDIR}/svgpasses
	rm -f $(BINDIR)/semantics $(BINDIR)/scanner $(BINDIR)/parser \
		$(BINDIR)/emitter ${BINDIR}/js-emitter \
		${BINDIR}/svgjspasses*
	rm -f $(PASSES-REGRESSION)
