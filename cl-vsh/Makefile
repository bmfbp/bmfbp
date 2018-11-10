#  build the components and mv them to ~/bin

BINDIR = ~/bin

execs =  $(BINDIR)/scan $(BINDIR)/check-input $(BINDIR)/calc-bounds $(BINDIR)/mark-directions \
	$(BINDIR)/match-ports-to-components $(BINDIR)/assign-pipe-numbers-to-inputs \
	$(BINDIR)/assign-pipe-numbers-to-outputs $(BINDIR)/assign-fds $(BINDIR)/emit-grash 

all : $(execs) io.lisp

$(BINDIR)/% : %.lisp io.lisp
	rm -f $@
	buildapp --output $@  --load $< --entry main

clean:
	rm -f $(execs)
