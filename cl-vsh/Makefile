#  build the components and mv them to ~/bin

BINDIR = ~/bin

EXECS = $(BINDIR)/scan \
	$(BINDIR)/check-input \
	$(BINDIR)/calc-bounds $(BINDIR)/mark-directions \
	$(BINDIR)/match-ports-to-components \
	$(BINDIR)/assign-pipe-numbers-to-inputs \
	$(BINDIR)/assign-pipe-numbers-to-outputs \
	$(BINDIR)/assign-fds \
	$(BINDIR)/emit-grash

BOOTSTRAP=$(BINDIR)/bootstrap.gsh
DIA-COMPILER=$(BINDIR)/vsh.gsh
REGRESS-COMPILER=dia-regression-compiler.gsh

all : misc $(EXECS) $(BOOTSTRAP)

regression : all $(BOOTSTRAP)
	$(BINDIR)/grash $(DIA-COMPILER) vsh.graphml >$(REGRESS-COMPILER)
	sleep 1  # need to wait for the network to die down
	diff -q $(DIA-COMPILER) $(REGRESS-COMPILER)

execs : misc $(EXECS)

clean:
	rm -f $(EXECS) $(BOOTSTRAP) misc $(REGRESS-COMPILER) $(DIA-COMPILER)
	rm -f *.lispfb

cleanfb:
	rm -f *.lispfb

$(BINDIR)/% : %.lisp io.lisp
	buildapp --output $@   --load io.lisp --load $< --entry main

misc : 
	mkdir -p $(BINDIR)
	touch misc

$(BOOTSTRAP) : $(EXECS)
	$(BINDIR)/scan vsh.graphml >1.lispfb
	$(BINDIR)/check-input <1.lispfb >2.lispfb
	$(BINDIR)/calc-bounds <2.lispfb >3.lispfb
	$(BINDIR)/mark-directions <3.lispfb >4.lispfb
	$(BINDIR)/match-ports-to-components <4.lispfb >5.lispfb
	$(BINDIR)/assign-pipe-numbers-to-inputs <5.lispfb >6.lispfb
	$(BINDIR)/assign-pipe-numbers-to-outputs <6.lispfb >7.lispfb
	$(BINDIR)/assign-fds <7.lispfb >8.lispfb
	$(BINDIR)/emit-grash <8.lispfb >$(BOOTSTRAP)
	cp $(BOOTSTRAP) $(DIA-COMPILER)

