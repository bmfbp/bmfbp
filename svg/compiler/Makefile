BINDIR=~/bin
SVG_DIAGRAM=svg_compiler.svg
REGRESSION=regression.gsh

dependencies:
	mkdir -p $(BINDIR)
	cp bmfbp.sh $(BINDIR)/bmfbp
	chmod a+x $(BINDIR)/bmfbp
	cp svg.gsh $(BINDIR)

clean: clean-temps
	rm -f $(BINDIR)/bmfbp $(BINDIR)/svg.gsh $(REGRESSION)

clean-temps:
	rm -f *.pro
	rm -f temp1.lisp temp.gsh

test : dependencies
	bmfbp $(SVG_DIAGRAM) >$(REGRESSION)
	diff -q $(BINDIR)/svg.gsh $(REGRESSION)
