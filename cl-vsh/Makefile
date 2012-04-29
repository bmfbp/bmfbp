bindir = ~/bin

execs =  $(bindir)/scan $(bindir)/check-input $(bindir)/calc-bounds $(bindir)/mark-directions \
	$(bindir)/match-ports-to-components $(bindir)/assign-pipe-numbers-to-inputs \
	$(bindir)/assign-pipe-numbers-to-outputs $(bindir)/assign-fds $(bindir)/emit-grash 

all : $(execs) io.lisp

$(bindir)/% : %.lisp io.lisp
	rm -f $@
	buildapp --output $@  --load $< --entry main

clean:
	rm -f $(execs)
