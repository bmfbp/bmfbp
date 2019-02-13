# usage:
# linux: svgpasses <name> > <outfile>
# js   : svgjs     <name> > <outfile.js>


BINDIR=~/bin
SVG_DIAGRAM=svgc.svg
REGRESSION=regression.gsh
PASSES-REGRESSION=passes-regression.gsh

all: dependencies

svgjs : dependencies ./build-svgjs
	./build-svgjs

dependencies:
	mkdir -p $(BINDIR)
	cp bmfbp.sh $(BINDIR)/bmfbp
	chmod a+x $(BINDIR)/bmfbp
	cp svg.gsh $(BINDIR)

clean: clean-temps clean-passes
	rm -f $(BINDIR)/bmfbp $(BINDIR)/svg.gsh $(REGRESSION)

clean-temps:
	rm -f *.pro
	rm -f temp1.lisp temp18.gsh

test : dependencies
	bmfbp $(SVG_DIAGRAM) >$(REGRESSION)
	sleep 1
	diff -q $(BINDIR)/svg.gsh $(REGRESSION)

passes :
	bmfbp passes.svg >$(BINDIR)/svgpasses.gsh
	bmfbp scanner.svg >$(BINDIR)/scanner.gsh
	bmfbp parser.svg >$(BINDIR)/parser.gsh
	bmfbp emitter.svg >$(BINDIR)/emitter.gsh
	bmfbp js-emitter.svg >$(BINDIR)/js-emitter.gsh
	cp svgpasses svgjs scanner parser semantic emitter js-emitter $(BINDIR)
	chmod a+x $(BINDIR) $(BINDIR)/svgpasses
	chmod a+x $(BINDIR) $(BINDIR)/svgjs
	chmod a+x $(BINDIR) $(BINDIR)/scanner
	chmod a+x $(BINDIR) $(BINDIR)/parser
	chmod a+x $(BINDIR) $(BINDIR)/semantic
	chmod a+x $(BINDIR) $(BINDIR)/emitter
	chmod a+x $(BINDIR) $(BINDIR)/js-emitter

test-passes: passes
	bmfbp $(SVG_DIAGRAM) >$(REGRESSION)
	svgpasses svgc <$(SVG_DIAGRAM) >$(PASSES-REGRESSION)
	sleep 1
	diff -q $(PASSES-REGRESSION) $(REGRESSION)

clean-passes :
	rm -f $(BINDIR)/svgpasses.gsh $(BINDIR)/scanner.gsh \
		$(BINDIR)/parser.gsh $(BINDIR)/emitter.gsh \
		${BINDIR}/js-emitter.gsh ${BINDIR}/svgjs.gsh
	rm -f $(BINDIR)/semantic $(BINDIR)/scanner $(BINDIR)/parser \
		$(BINDIR)/emitter ${BINDIR}/js-emitter
	rm -f $(PASSES-REGRESSION)
