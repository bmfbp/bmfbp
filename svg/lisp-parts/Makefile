BINDIR=~/bin

LISPS = $(BINDIR)/lwpasses*

all : $(LISPS) $(BINDIR)/plsort $(BINDIR)/lib_insert_part_name $(BINDIR)/unmap-strings $(BINDIR)/emit_js2 $(BINDIR)/new_emit_js2 $(BINDIR)/lisp-to-prolog $(BINDIR)/prolog-to-lisp $(BINDIR)/calc_bounds

$(BINDIR)/lwpasses:
	./deliver.sh

$(BINDIR)/lisp-to-prolog:
	cp lisp-to-prolog.sh $(BINDIR)/lisp-to-prolog

$(BINDIR)/prolog-to-lisp:
	cp prolog-to-lisp.sh $(BINDIR)/prolog-to-lisp

$(BINDIR)/plsort:
	mkdir -p $(BINDIR)
	echo "#!/bin/sh" >$(BINDIR)/plsort
	echo "sort" >>$(BINDIR)/plsort
	chmod a+x $(BINDIR)/plsort

$(BINDIR)/% : %.pl $(PL_COMMON)
	gplc $< --output $@ --no-top-level

$(BINDIR)/calc_bounds:
	buildapp --output $(BINDIR)/calc_bounds \
		--load common.lisp \
		--load calc_bounds.lisp \
		--entry main


$(BINDIR)/unmap-strings: unmap-strings.lisp
	buildapp --output $(BINDIR)/unmap-strings \
		--load util.lisp \
		--load unmap-strings.lisp \
		--entry main

$(BINDIR)/lib_insert_part_name: lib_insert_part_name.lisp
	buildapp --output $(BINDIR)/lib_insert_part_name --load lib_insert_part_name.lisp --entry main

# for looking back at index-based pins (testing new version)
$(BINDIR)/emit_js2: emit_js2.lisp
	buildapp --output $(BINDIR)/emit_js2 \
		--load util.lisp \
		--load emit_js2.lisp \
		--entry main

$(BINDIR)/new_emit_js2: new_emit_js2.lisp
	buildapp --output $(BINDIR)/new_emit_js2 \
		--load util.lisp \
		--load new_emit_js2.lisp \
		--entry main

clean :
	rm -f $(LISPS)
	rm -f $(EXECS)
	rm -f $(BINDIR)/fb_to_prolog $(BINDIR)/plsort \
	$(BINDIR)/lib_insert_part_name $(BINDIR)/unmap-strings
	rm -f $(BINDIR)/emit_js[23]*
	rm -f $(BINDIR)/new_emit_js[23]*
	rm -f $(BINDIR)/lisp-to-prolog $(BINDIR)/prolog-to-lisp
	rm -rf ~/.cache/common-lisp/
