BINDIR=~/bin

LISPS = $(BINDIR)/lwpasses

all : $(BINDIR)/lisp-to-prolog $(BINDIR)/prolog-to-lisp

$(BINDIR)/lwpasses:
	./deliver.sh

$(BINDIR)/lisp-to-prolog:
	cp lisp-to-prolog.sh $(BINDIR)/lisp-to-prolog

$(BINDIR)/prolog-to-lisp:
	cp prolog-to-lisp.sh $(BINDIR)/prolog-to-lisp

clean :
	rm -f $(LISPS)
	rm -rf ~/.cache/common-lisp/
