#  build the lisp svg to factbase converter and mv it to ~/bin

BINDIR = ~/bin

execs =  $(BINDIR)/svg-to-fb

all : $(execs)

$(BINDIR)/svg-to-fb : main.lisp arrows.lisp tofb.lisp translate.lisp
	rm -f $@
	buildapp --output $(BINDIR)/svg-to-fb --load arrows.lisp --load tofb.lisp --load translate.lisp --load main.lisp --entry run

clean:
	rm -f $(execs)
