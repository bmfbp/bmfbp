BINDIR=~/bin

$(BINDIR)/d2json: main.lisp
	~/quicklisp/local-projects/rm.bash
	buildapp \
		--load ~/quicklisp/setup.lisp \
		--eval '(ql:quickload :sl)' \
		--eval '(ql:quickload :arrowgrams/build)' \
		--load main.lisp \
		--output $(BINDIR)/d2json \
		--entry main

clean :
	rm -f $(EXECS)

