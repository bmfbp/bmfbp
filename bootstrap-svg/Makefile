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

BOOTSTRAP_COMPILER=$(BINDIR)/pl_bootstrap.gsh
YED_DIAGRAM=yed_svg_compiler.graphml
YED_BASED_COMPILER=$(BINDIR)/pl_svg_bootstrap_vsh.gsh

# real SVG compiler written as an SVG/XML diagram
YED_COMPILER_AS_SVG=yed_compiler_as_svg.svg
LISP_FROM_SVG=lisp-from-svg.lisp
SVG_COMPILER_PROLOGFB=svg_compiler.pro

BOOTSTRAP_COMPILER_OUTPUT=bootstrap-output.pro

TEMP1=temp1.lisp
TEMP2=temp2.pro

LOCAL_PL=$(BINDIR)/boot_add_kinds $(BINDIR)/boot_make_unknown_port_names

all : misc bootstrap $(BINDIR)/fb-to-prolog make-yed-based-compiler $(LOCAL_PL) test-yed-based-compiler

make-yed-based-compiler: misc dependencies bootstrap $(YED_DIAGRAM)
	$(grash) $(BOOTSTRAP_COMPILER) $(YED_DIAGRAM) >$(YED_BASED_COMPILER)
	sleep 1  # need to wait for the network to die down

test-yed-based-compiler : make-yed-based-compiler $(YED_DIAGRAM_AS_SVG)
	$(grash) $(YED_BASED_COMPILER) $(YED_COMPILER_AS_SVG) >$(BOOTSTRAP_COMPILER_OUTPUT)

bootstrap : dependencies

temps: $(YED_COMPILER_AS_SVG)
	# Prelude.head empty list IFF you try pass the .svg in as stdin instead of as 1st arg on command line
	svg-to-lisp $(YED_COMPILER_AS_SVG) >$(TEMP1)
	fb-to-prolog <$(TEMP1) >$(TEMP2)

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
	rm -f $(SVG_BOOTSTRAP_COMPILER) misc $(TEST_LISP) $(TEST_FB) $(LOCAL_PL) \
	$(SVG_BOOTSTRAP_COMPILER) $(LISP_FROM_SVG) $(SVG_COMPILER_PROLOGFB)
	rm -f *.pro

cleanfb:
	rm -f *.pro

$(BINDIR)/boot_add_kinds : boot_add_kinds.pl
	gplc $< --output $(BINDIR)/boot_add_kinds --no-top-level

$(BINDIR)/boot_make_unknown_port_names : boot_make_unknown_port_names.pl
	gplc $< --output $(BINDIR)/boot_make_unknown_port_names --no-top-level

# $(BINDIR)/boot_% : boot_%.pl
# 	gplc $< --output $@ --no-top-level

misc : 
	mkdir -p $(BINDIR)
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

