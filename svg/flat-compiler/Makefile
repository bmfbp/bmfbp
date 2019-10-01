BINDIR=~/bin
SVG_DIAGRAM=svgc.svg
REGRESSION=regression.gsh
TESTAGAINST=testagainst.gsh-notignored

all: linux-based-compiler

linux-based-compiler: dependencies
# the linux-based compiler is used to compile the compiler for compiling js (build-js)

clean: clean-dependencies
	rm -f $(BINDIR)/svg.gsh $(REGRESSION) $(BINDIR)/flatbmfbp
	rm -f /tmp/temp.gsh /tmp/regression.gsh
	rm -f *.pro
	rm -f temp1.lisp temp18.lisp temp19.js temp2.lisp
	rm -f temp.gsh temp18.gsh temp19.js
	rm -f temp-string-map.lisp

test: dependencies
	flatbmfbp $(SVG_DIAGRAM) >$(REGRESSION)
	comparegsh.sh $(REGRESSION) $(TESTAGAINST)

dependencies:
	mkdir -p $(BINDIR)
# need already-built flat compiler in ~/bin	
	cp svg.gsh-notignored $(BINDIR)/svg.gsh
# script to build an svg file using the already-built svg.gsh
	cp flatbmfbp.sh $(BINDIR)/flatbmfbp
	chmod a+x $(BINDIR)/flatbmfbp
# script to compare regression files (using sed to normalize them)
	cp comparegsh.sh $(BINDIR)/comparegsh.sh
	chmod a+x $(BINDIR)/comparegsh.sh

clean-dependencies:
	rm -f $(BINDIR)/flatbmfbp $(BINDIR)/comparegsh.sh
