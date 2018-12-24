# We expect to use the EXECS already built in ../pl_vsh (see rule pl_vsh below)
# We need to add some prolog files for compiling SVG (produced by draw.io, along with some conventions).
#  Those "new" prolog files are prefixed with "svg_" to distinguish them from the ../pl_vsh commands

# During bootstrapping, we use the yEd editor to create a new svg_compiler.gsh.  yEd is a compatible
#  with the programs in ../pl_vsh.  This allows us to use a diagram (yEd) to describe how the SVG
#  compiler works.  Later, we use the SVG diagram compiler for everthing and we will regression test
#  it against itself.
# Eventually, after bootstrapping, yEd will completely disappear from the work flow.

#  build the components and mv them to ~/bin

BINDIR = ~/bin
grash=$(BINDIR)/grash

PL_COMMON=../common/head.pl ../common/tail.pl

BOOTSTRAP_COMPILER=$(BINDIR)/pl_bootstrap.gsh
YED_DIAGRAM=yed_svg_compiler.graphml
YED_BASED_COMPILER=$(BINDIR)/pl_svg_bootstrap_vsh.gsh

# real SVG compiler written as an SVG/XML diagram
YED_COMPILER_AS_SVG=yed_compiler_as_svg.svg
LISP_FROM_SVG=lisp-from-svg.lisp
SVG_COMPILER_PROLOGFB=svg_compiler.pro

BOOTSTRAP_COMPILER_OUTPUT=bootstrap-output.pro
BOOTSTRAP_SVG_COMPILER=$(BINDIR)/bootstrap-svg.gsh

TEMP1=temp1.lisp
TEMP1A=temp1A.pro
TEMP2=temp2.pro
TEMP3=temp3.pro
TEMP4=temp4.pro
TEMP5=temp5.pro
TEMP6=temp6.pro
TEMP7=temp7.pro
TEMP8=temp8.pro
TEMP9=temp9.pro
TEMP10=temp10.pro
TEMP11=temp11.pro
TEMP12=temp12.pro
TEMP13=temp13.pro
TEMP14=temp14.pro
TEMP15=temp15.pro


LOCAL_PL=$(BINDIR)/boot_add_kinds $(BINDIR)/boot_create_centers \
	$(BINDIR)/boot_calculate_distances $(BINDIR)/boot_make_unknown_port_names \
	$(BINDIR)/boot_assign_portnames \
#	$(BINDIR)/boot_match_ports_to_components

all : misc bootstrap $(BINDIR)/fb-to-prolog make-yed-based-compiler $(LOCAL_PL) \
	test-yed-based-compiler \
	bootstrap-svg-compiler

make-yed-based-compiler: misc dependencies bootstrap $(YED_DIAGRAM)
	$(grash) $(BOOTSTRAP_COMPILER) $(YED_DIAGRAM) >$(YED_BASED_COMPILER)
	sleep 1  # need to wait for the network to die down

test-yed-based-compiler : make-yed-based-compiler $(YED_DIAGRAM_AS_SVG)
	$(grash) $(YED_BASED_COMPILER) $(YED_COMPILER_AS_SVG) >$(BOOTSTRAP_COMPILER_OUTPUT)
	sleep 1  # need to wait for the network to die down

bootstrap-svg-compiler: all
	cp $(BOOTSTRAP_COMPILER_OUTPUT) $(BOOTSTRAP_SVG_COMPILER)

bootstrap : dependencies

regression : all
	@echo 'cannot do regression, since port numbers are chosen at random'

# Prelude.head empty list IFF you try pass the .svg in as stdin instead of as 1st arg on command line
temps: all-no-test
	svg-to-lisp $(YED_COMPILER_AS_SVG) >$(TEMP1)
	fb-to-prolog <$(TEMP1) >$(TEMP1A)
	boot_insert <$(TEMP1A) >$(TEMP2)
	plsort <$(TEMP2) >$(TEMP3)
	pl_check_input <$(TEMP3) >$(TEMP4)
	pl_calc_bounds <$(TEMP4) >$(TEMP5)
	boot_add_kinds <$(TEMP5) >$(TEMP6)
	boot_make_unknown_port_names <$(TEMP6) >$(TEMP7)
	boot_create_centers <$(TEMP7) >$(TEMP8)
	boot_calculate_distances <$(TEMP8) >$(TEMP9)
	boot_assign_portnames <$(TEMP9) >$(TEMP10)
	pl_mark_directions <$(TEMP10) >$(TEMP11)
	pl_match_ports_to_components <$(TEMP11) >$(TEMP12)
	pl_assign_pipe_numbers_to_inputs <$(TEMP12) >$(TEMP13)
	pl_assign_pipe_numbers_to_outputs <$(TEMP13) >$(TEMP14)
	pl_assign_fds <$(TEMP14) >$(TEMP15)
	pl_emit <$(TEMP15) >$(BOOTSTRAP_COMPILER_OUTPUT)



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

clean:
	rm -f $(BOOTSTRAP_SVG_COMPILER) misc $(TEST_LISP) $(TEST_FB) $(LOCAL_PL) \
	$(SVG_BOOTSTRAP_COMPILER) $(LISP_FROM_SVG) $(SVG_COMPILER_PROLOGFB) 
	rm -f $(TEMP1) $(TEMP2) $(TEMP3) $(TEMP4) $(TEMP5) $(TEMP6) $(TEMP7) \
	$(TEMP8) $(TEMP9) $(TEMP10) $(TEMP11) $(TEMP12) 
	rm -f $(BINDIR)/boot_emit $(BINDIR)/boot_match_ports_to_components
	rm -f *.pro

cleanfb:
	rm -f *.pro

$(BINDIR)/boot_add_kinds : boot_add_kinds.pl $(PL_COMMON)
	gplc $< --output $(BINDIR)/boot_add_kinds --no-top-level

$(BINDIR)/boot_make_unknown_port_names : boot_make_unknown_port_names.pl $(PL_COMMON)
	gplc $< --output $(BINDIR)/boot_make_unknown_port_names --no-top-level

$(BINDIR)/boot_create_centers : boot_create_centers.pl $(PL_COMMON)
	gplc $< --output $(BINDIR)/boot_create_centers --no-top-level

$(BINDIR)/boot_calculate_distances : boot_calculate_distances.pl $(PL_COMMON)
	gplc $< --output $(BINDIR)/boot_calculate_distances --no-top-level

$(BINDIR)/boot_assign_portnames : boot_assign_portnames.pl $(PL_COMMON)
	gplc $< --output $(BINDIR)/boot_assign_portnames --no-top-level

# $(BINDIR)/boot_match_ports_to_components : boot_match_ports_to_components.pl $(PL_COMMON)
#	gplc $< --output $(BINDIR)/boot_match_ports_to_components --no-top-level

# $(BINDIR)/boot_emit : boot_emit.pl $(PL_COMMON)
# 	gplc $< --output $(BINDIR)/boot_emit --no-top-level

# $(BINDIR)/boot_% : boot_%.pl $(PL_COMMON)
# 	gplc $< --output $@ --no-top-level

misc : 
	mkdir -p $(BINDIR)

	echo "#!/bin/sh" >$(BINDIR)/boot_insert
	echo "echo 'component(top).'" >>$(BINDIR)/boot_insert
	echo "cat -" >>$(BINDIR)/boot_insert
	chmod a+x $(BINDIR)/boot_insert

	echo "#!/bin/sh" >$(BINDIR)/plsort
	echo "sort" >>$(BINDIR)/plsort
	chmod a+x $(BINDIR)/plsort

	# this needs to be replaced by a make of svg-to-lisp - currently this over-fills my Dropbox
	cp ~/projects/svg-to-fb/svg-to-fb-mac ~/bin/svg-to-lisp
	chmod a+x ~/bin/svg-to-lisp
	touch misc

dependencies :
	cd ../grash && make all
	cd ../pl_vsh && make all

