# We expect to use the EXECS already built in ../pl_vsh (see rule pl_vsh below)
# We need to add some prolog files for compiling SVG (produced by draw.io, along with some conventions).
#  Those "new" prolog files are prefixed with "svg_" to distinguish them from the ../pl_vsh commands

#  build the components and mv them to ~/bin

BINDIR = ~/bin
grash=$(BINDIR)/grash

BOOTSTRAP_COMPILER=$(BINDIR)/bootstrap-svg.gsh
SVG_DIAGRAM=svg_compiler.svg
SVG_OUTPUT=svg.gsh

LOCAL_PL=$(BINDIR)/svg_emit $(BINDIR)/svg_match_ports_to_components

all : misc bootstrap
	$(grash) $(BOOTSTRAP_COMPILER) $(SVG_DIAGRAM) >$(SVG_OUTPUT)

clean:
	rm -f $(BOOTSTRAP_SVG_COMPILER) misc $(TEST_LISP) $(TEST_FB) $(LOCAL_PL) \
	$(SVG_BOOTSTRAP_COMPILER) $(LISP_FROM_SVG) $(SVG_COMPILER_PROLOGFB) 
	rm -f $(TEMP1) $(TEMP2) $(TEMP3) $(TEMP4) $(TEMP5) $(TEMP6) $(TEMP7) \
	$(TEMP8) $(TEMP9) $(TEMP10) $(TEMP11) $(TEMP12) 
	rm -f $(BINDIR)/boot_emit $(BINDIR)/boot_match_ports_to_components
	rm -f *.pro

cleanfb:
	rm -f *.pro

misc : 
	touch misc

bootstrap: $(BOOTSTRAP_COMPILER)
	cd ../bootstrap-svg && make all

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
TEMP16=temp16.gsh

$(BINDIR)/svg_match_ports_to_components : svg_match_ports_to_components.pl $(PL_COMMON)
	gplc $< --output $(BINDIR)/svg_match_ports_to_components --no-top-level

$(BINDIR)/svg_emit : svg_emit.pl $(PL_COMMON)
	gplc $< --output $(BINDIR)/svg_emit --no-top-level

temps: bootstrap $(LOCAL_PL)
	svg-to-lisp $(SVG_DIAGRAM) >$(TEMP1)
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
	svg_match_ports_to_components <$(TEMP11) >$(TEMP12)
	pl_assign_pipe_numbers_to_inputs <$(TEMP12) >$(TEMP13)
	pl_assign_pipe_numbers_to_outputs <$(TEMP13) >$(TEMP14)
	pl_assign_fds <$(TEMP14) >$(TEMP15)
	svg_emit <$(TEMP15) >$(TEMP16)
