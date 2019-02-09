BINDIR=~/bin
SVG_DIAGRAM=svgc.svg
REGRESSION=regression.gsh
PASSES-REGRESSION=passes-regression.gsh

all: dependencies

dependencies:
	mkdir -p $(BINDIR)
	cp bmfbp.sh $(BINDIR)/bmfbp
	chmod a+x $(BINDIR)/bmfbp
	cp svg.gsh $(BINDIR)
	cp comparegsh.sh $(BINDIR)
	chmod a+x $(BINDIR)/comparegsh.sh

clean: clean-temps clean-passes
	rm -f $(BINDIR)/bmfbp $(BINDIR)/svg.gsh $(REGRESSION)

clean-temps:
	rm -f *.pro
	rm -f temp1.lisp temp18.gsh

test : dependencies
	bmfbp $(SVG_DIAGRAM) >$(REGRESSION)
	$(BINDIR)/comparegsh.sh $(BINDIR)/svg.gsh $(REGRESSION)

passes :
	bmfbp passes.svg >$(BINDIR)/svgpasses.gsh
	bmfbp scanner.svg >$(BINDIR)/scanner.gsh
	bmfbp parser.svg >$(BINDIR)/parser.gsh
	bmfbp emitter.svg >$(BINDIR)/emitter.gsh
	cp svgpasses scanner parser semantic emitter $(BINDIR)
	chmod a+x $(BINDIR) $(BINDIR)/svgpasses
	chmod a+x $(BINDIR) $(BINDIR)/scanner
	chmod a+x $(BINDIR) $(BINDIR)/parser
	chmod a+x $(BINDIR) $(BINDIR)/semantic
	chmod a+x $(BINDIR) $(BINDIR)/emitter

test-passes: passes
	bmfbp $(SVG_DIAGRAM) >$(REGRESSION)
	svgpasses svgc <$(SVG_DIAGRAM) >$(PASSES-REGRESSION)
	sleep 1
	diff -q $(PASSES-REGRESSION) $(REGRESSION)

clean-passes :
	rm -f $(BINDIR)/svgpasses.gsh $(BINDIR)/scanner.gsh $(BINDIR)/parser.gsh $(BINDIR)/emitter.gsh
	rm -f $(BINDIR)/semantic $(BINDIR)/scanner $(BINDIR)/parser $(BINDIR)/emitter
	rm -f $(PASSES-REGRESSION)
