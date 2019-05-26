BINDIR=~/bin

EXECS = $(BINDIR)/check_input \
	$(BINDIR)/calc_bounds \
	$(BINDIR)/mark_directions \
	$(BINDIR)/assign_wire_numbers_to_inputs \
	$(BINDIR)/assign_wire_numbers_to_outputs \
	$(BINDIR)/assign_portIndices \
	$(BINDIR)/emit \
	$(BINDIR)/emit_js \
	$(BINDIR)/inOutPins \
	$(BINDIR)/add_kinds \
	$(BINDIR)/add_selfPorts \
	$(BINDIR)/assign_portnames \
	$(BINDIR)/calculate_distances \
	$(BINDIR)/create_centers \
	$(BINDIR)/make_unknown_port_names \
	$(BINDIR)/match_ports_to_components \
	$(BINDIR)/sem_partsHaveSomePorts \
	$(BINDIR)/sem_allPortsHaveAnIndex \
	$(BINDIR)/markIndexedPorts \
	$(BINDIR)/coincidentPorts \
	$(BINDIR)/lib_insert_part_name

all : $(EXECS) $(BINDIR)/plsort $(BINDIR)/fb-to-prolog $(BINDIR)/lib_insert_part_name $(BINDIR)/emit_js2

$(BINDIR)/plsort:
	mkdir -p $(BINDIR)
	echo "#!/bin/sh" >$(BINDIR)/plsort
	echo "sort" >>$(BINDIR)/plsort
	chmod a+x $(BINDIR)/plsort

$(BINDIR)/% : %.pl $(PL_COMMON)
	gplc $< --output $@ --no-top-level

$(BINDIR)/fb-to-prolog: util.lisp toprolog.lisp fix-translate.lisp collapse-lines.lisp create-text-objects.lisp \
	            fix-arrows.lisp fix-lines.lisp main.lisp
	buildapp --output $(BINDIR)/fb-to-prolog \
		--load util.lisp \
		--load toprolog.lisp \
		--load fix-translate.lisp \
		--load collapse-lines.lisp \
		--load create-text-objects.lisp \
		--load fix-arrows.lisp \
		--load fix-lines.lisp \
		--load main.lisp \
		--entry main

$(BINDIR)/lib_insert_part_name: lib_insert_part_name.lisp
	buildapp --output $(BINDIR)/lib_insert_part_name --load lib_insert_part_name.lisp --entry main

$(BINDIR)/emit_js2: emit_js2.lisp
	buildapp --output $(BINDIR)/emit_js2 --load emit_js2.lisp --entry main

clean :
	rm -f $(EXECS)
	rm -f $(BINDIR)/fb-to-prolog $(BINDIR)/plsort $(BINDIR)/lib_insert_part_name 
	rm -f $(BINDIR)/emit_js2

