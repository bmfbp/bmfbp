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

clean: clean-temps clean-passes
	rm -f $(BINDIR)/bmfbp $(BINDIR)/svg.gsh $(REGRESSION)

clean-temps:
	rm -f *.pro
	rm -f temp1.lisp temp18.gsh

test : dependencies
	bmfbp $(SVG_DIAGRAM) >$(REGRESSION)
	sleep 1
	cp $(BINDIR)/svg.gsh ./temp.gsh
	comparegsh.sh temp.gsh $(REGRESSION)

passes :
	bmfbp passes.svg >$(BINDIR)/svgpasses.gsh
	bmfbp scanner.svg >$(BINDIR)/scanner.gsh
	bmfbp parser.svg >$(BINDIR)/parser.gsh
	bmfbp semantics.svg >$(BINDIR)/semantics.gsh
	bmfbp emitter.svg >$(BINDIR)/emitter.gsh
	cp svgpasses scanner parser semantics emitter unity comparegsh.sh $(BINDIR)
	chmod a+x $(BINDIR)/svgpasses $(BINDIR)/unity $(BINDIR)/scanner $(BINDIR)/parser $(BINDIR)/semantics $(BINDIR)/emitter $(BINDIR)/comparegsh.sh

test-passes: passes
	bmfbp $(SVG_DIAGRAM) >$(REGRESSION)
	svgpasses svgc <$(SVG_DIAGRAM) >$(PASSES-REGRESSION)
	sleep 1
	$(BINDIR)/comparegsh.sh $(PASSES-REGRESSION) $(REGRESSION)

clean-passes :
	rm -f $(BINDIR)/svgpasses.gsh $(BINDIR)/scanner.gsh $(BINDIR)/parser.gsh $(BINDIR)/emitter.gsh
	rm -f $(BINDIR)/semantic $(BINDIR)/scanner $(BINDIR)/parser $(BINDIR)/emitter
	rm -f $(PASSES-REGRESSION)
