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
	rm -f temp1.lisp temp18.gsh junk.lisp

test : dependencies
	bmfbp $(SVG_DIAGRAM) >$(REGRESSION)
	diff -q $(BINDIR)/svg.gsh $(REGRESSION)

passes :
	bmfbp passes.svg >$(BINDIR)/svgpasses.gsh
	bmfbp scanner.svg >$(BINDIR)/scanner.gsh
	bmfbp parser.svg >$(BINDIR)/parser.gsh
	bmfbp emitter.svg >$(BINDIR)/emitter.gsh
	echo "#!/bin/bash\ngrash $(BINDIR)/scanner.gsh" >$(BINDIR)/scanner
	echo "#!/bin/bash\ngrash $(BINDIR)/parser.gsh" >$(BINDIR)/parser
	echo '#!/bin/bash\ncat -' >$(BINDIR)/semantic
	echo "#!/bin/bash\ngrash $(BINDIR)/emitter.gsh" >$(BINDIR)/emitter
	chmod a+x $(BINDIR) $(BINDIR)/scanner
	chmod a+x $(BINDIR) $(BINDIR)/parser
	chmod a+x $(BINDIR) $(BINDIR)/semantic
	chmod a+x $(BINDIR) $(BINDIR)/emitter

test-passes: passes
	bmfbp $(SVG_DIAGRAM) >$(REGRESSION)
	grash $(BINDIR)/svgpasses.gsh svgc <$(SVG_DIAGRAM) >$(PASSES-REGRESSION)
	sleep 1
	diff -q $(PASSES-REGRESSION) $(REGRESSION)

clean-passes :
	rm -f $(BINDIR)/svgpasses.gsh $(BINDIR)/scanner.gsh $(BINDIR)/parser.gsh $(BINDIR)/emitter.gsh
	rm -f $(BINDIR)/semantic $(BINDIR)/scanner $(BINDIR)/parser $(BINDIR)/emitter
	rm -f $(PASSES-REGRESSION)

junk:
	hs-vsh-drawio-to-fb junk <junk.svg >junk.lisp
