# usage:
# linux: svgpasses <name> > <outfile>
# js   : svgjs     <name> > <outfile.js>


BINDIR=~/bin
SVG_DIAGRAM=svgc.svg
REGRESSION=regression.gsh
PASSES-REGRESSION=passes-regression.gsh

all: dependencies passes

svgjs : dependencies ./build-svgjs
	./build-svgjs

dependencies:
	mkdir -p $(BINDIR)
	cp bmfbp.sh $(BINDIR)/bmfbp
	cp flatbmfbp.sh $(BINDIR)/flatbmfbp
	chmod a+x $(BINDIR)/bmfbp
	chmod a+x $(BINDIR)/flatbmfbp
	cp svg.gsh $(BINDIR)

clean: clean-temps clean-passes
	rm -f $(BINDIR)/bmfbp $(BINDIR)/svg.gsh $(REGRESSION) $(BINDIR)/flatbmfbp

clean-temps:
	rm -f *.pro
	rm -f temp1.lisp temp18.gsh

test : dependencies
	flatbmfbp $(SVG_DIAGRAM) >$(REGRESSION)
	sleep 1
	cp $(BINDIR)/svg.gsh ./temp.gsh
	comparegsh.sh temp.gsh $(REGRESSION)

passes :
	flatbmfbp passes.svg >$(BINDIR)/svgpasses.gsh
	flatbmfbp scanner.svg >$(BINDIR)/scanner.gsh
	flatbmfbp parser.svg >$(BINDIR)/parser.gsh
	flatbmfbp semantics.svg >$(BINDIR)/semantics.gsh
	flatbmfbp emitter.svg >$(BINDIR)/emitter.gsh
	cp svgpasses scanner parser semantics emitter unity comparegsh.sh $(BINDIR)
	chmod a+x $(BINDIR)/svgpasses $(BINDIR)/unity $(BINDIR)/scanner $(BINDIR)/parser $(BINDIR)/semantics $(BINDIR)/emitter $(BINDIR)/comparegsh.sh

test-passes: passes
# semantics is contained only in svgpasses version
	svgpasses <passes.svg >temp200.pro
	sleep 1
	flatbmfbp $(SVG_DIAGRAM) >$(REGRESSION)
	svgpasses svgc <$(SVG_DIAGRAM) >$(PASSES-REGRESSION)
	$(BINDIR)/comparegsh.sh $(PASSES-REGRESSION) $(REGRESSION)
	sleep 1
	flatbmfbp passes.svg >$(REGRESSION)
	svgpasses passes <passes.svg >$(PASSES-REGRESSION)
	$(BINDIR)/comparegsh.sh $(PASSES-REGRESSION) $(REGRESSION)

clean-passes :
	rm -f $(BINDIR)/svgpasses.gsh $(BINDIR)/scanner.gsh \
		$(BINDIR)/parser.gsh $(BINDIR)/emitter.gsh \
		${BINDIR}/js-emitter.gsh ${BINDIR}/svgjs.gsh
	rm -f $(BINDIR)/semantics $(BINDIR)/scanner $(BINDIR)/parser \
		$(BINDIR)/emitter ${BINDIR}/js-emitter
	rm -f $(PASSES-REGRESSION)
