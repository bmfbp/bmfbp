# usage:
# linux: svgpasses <name> >


BINDIR=~/bin
SVG_DIAGRAM=svgc.svg
REGRESSION=regression.gsh
PASSES-REGRESSION=passes-regression.gsh

all: dependencies svg.gsh

dependencies:
	mkdir -p $(BINDIR)
	cp bmfbp.sh $(BINDIR)/bmfbp
	cp flatbmfbp.sh $(BINDIR)/flatbmfbp
	chmod a+x $(BINDIR)/bmfbp
	chmod a+x $(BINDIR)/flatbmfbp
	cp svg.gsh $(BINDIR)
	cp comparegsh.sh $(BINDIR)

clean: clean-temps clean-dependencies
	rm -f $(BINDIR)/bmfbp $(BINDIR)/svg.gsh $(REGRESSION) $(BINDIR)/flatbmfbp

clean-dependencies:
	rm -rf ${BINDIR}/bmfbp ${BINDIR}/flatbmfbp ${BINDIR}/svg.gsh ${BINDIR}/comparegsh.sh

clean-temps:
	rm -f *.pro
	rm -f temp1.lisp temp18.lisp temp19.js

test : dependencies
	flatbmfbp $(SVG_DIAGRAM) >$(REGRESSION)
	comparegsh.sh svg.gsh.old $(REGRESSION)

