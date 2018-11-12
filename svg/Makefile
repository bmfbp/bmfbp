#  build the lisp svg to factbase converter and mv it to ~/bin

BINDIR = ~/bin

execs =  $(BINDIR)/parsed-svg-to-fb

all : $(execs)

$(BINDIR)/parsed-svg-to-fb : main.lisp arrows.lisp tofb.lisp translate.lisp item.lisp
	rm -f $@
	buildapp --output $(BINDIR)/parsed-svg-to-fb --load item.lisp --load arrows.lisp --load tofb.lisp --load translate.lisp --load main.lisp --entry run

clean:
	rm -f $(execs)
