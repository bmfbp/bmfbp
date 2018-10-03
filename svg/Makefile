#  build the lisp svg to factbase converter and mv it to ~/bin

bindir = ~/bin

execs =  $(bindir)/svg-to-fb

all : $(execs)

$(bindir)/svg-to-fb : main.lisp arrows.lisp tofb.lisp translate.lisp
	rm -f $@
	buildapp --output $(bindir)/svg-to-fb --load arrows.lisp --load tofb.lisp --load translate.lisp --load main.lisp --entry run

clean:
	rm -f $(execs)
