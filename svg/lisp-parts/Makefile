BINDIR=~/bin

LISPS = $(BINDIR)/calc_bounds

EXECS =	$(BINDIR)/mark_directions \
	$(BINDIR)/assign_wire_numbers_to_edges \
	$(BINDIR)/selfInputPins \
	$(BINDIR)/selfOutputPins \
	$(BINDIR)/inputPins \
	$(BINDIR)/outputPins \
	$(BINDIR)/pinless \
	$(BINDIR)/assign_parents_to_ellipses \
	$(BINDIR)/assign_wire_numbers_to_inputs \
	$(BINDIR)/assign_wire_numbers_to_outputs \
	$(BINDIR)/assign_portIndices \
	$(BINDIR)/emit \
	$(BINDIR)/emit_js \
	$(BINDIR)/new_emit_js \
	$(BINDIR)/inOutPins \
	$(BINDIR)/add_kinds \
	$(BINDIR)/find_comments \
	$(BINDIR)/find_metadata \
	$(BINDIR)/isolate_metadata \
	$(BINDIR)/add_selfPorts \
	$(BINDIR)/assign_portnames \
	$(BINDIR)/calculate_distances \
	$(BINDIR)/create_centers \
	$(BINDIR)/make_unknown_port_names \
	$(BINDIR)/match_ports_to_components \
	$(BINDIR)/sem_partsHaveSomePorts \
	$(BINDIR)/sem_portsHaveSinkOrSource \
	$(BINDIR)/sem_noDuplicateKinds \
	$(BINDIR)/sem_speechVScomments \
	$(BINDIR)/sem_info \
	$(BINDIR)/loginfo \
	$(BINDIR)/dumplog \
	$(BINDIR)/markIndexedPorts \
	$(BINDIR)/coincidentPorts \
	$(BINDIR)/lib_insert_part_name


all : $(EXECS) $(BINDIR)/plsort $(BINDIR)/lib_insert_part_name $(BINDIR)/unmap-strings $(BINDIR)/emit_js2 $(BINDIR)/new_emit_js2 $(BINDIR)/lisp-to-prolog $(BINDIR)/prolog-to-lisp $(BINDIR)/calc_bounds

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
