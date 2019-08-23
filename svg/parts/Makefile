BINDIR=~/bin

EXECS = $(BINDIR)/check_input \
	$(BINDIR)/calc_bounds \
	$(BINDIR)/mark_directions \
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
	$(BINDIR)/sem_allPortsHaveAnIndex \
	$(BINDIR)/sem_noDuplicateKinds \
	$(BINDIR)/sem_speechVScomments \
	$(BINDIR)/sem_info \
	$(BINDIR)/loginfo \
	$(BINDIR)/dumplog \
	$(BINDIR)/markIndexedPorts \
	$(BINDIR)/coincidentPorts \
	$(BINDIR)/lib_insert_part_name

all : $(EXECS) $(BINDIR)/plsort $(BINDIR)/fb_to_prolog $(BINDIR)/lib_insert_part_name $(BINDIR)/emit_js3 $(BINDIR)/unmap-strings $(BINDIR)/emit_js2

$(BINDIR)/plsort:
	mkdir -p $(BINDIR)
	echo "#!/bin/sh" >$(BINDIR)/plsort
	echo "sort" >>$(BINDIR)/plsort
	chmod a+x $(BINDIR)/plsort

$(BINDIR)/% : %.pl $(PL_COMMON)
	gplc $< --output $@ --no-top-level

$(BINDIR)/fb_to_prolog: util.lisp toprolog.lisp fix-translate.lisp collapse-lines.lisp create-text-objects.lisp \
	            fix-arrows.lisp fix-lines.lisp main.lisp
	buildapp --output $(BINDIR)/fb_to_prolog \
		--load util.lisp \
		--load toprolog.lisp \
		--load fix-translate.lisp \
		--load collapse-lines.lisp \
		--load create-text-objects.lisp \
		--load fix-arrows.lisp \
		--load fix-lines.lisp \
		--load main.lisp \
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

$(BINDIR)/emit_js3: emit_js3.lisp
	buildapp --output $(BINDIR)/emit_js3 \
		--load util.lisp \
		--load loop-macros.lisp \
		--load emit_js3.lisp \
		--entry main

clean :
	rm -f $(EXECS)
	rm -f $(BINDIR)/fb_to_prolog $(BINDIR)/plsort \
	$(BINDIR)/lib_insert_part_name $(BINDIR)/unmap-strings
	rm -f $(BINDIR)/emit_js[23]*

