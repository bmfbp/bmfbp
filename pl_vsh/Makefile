#  build the components and mv them to ~/bin

BINDIR = ~/bin

EXECS = $(BINDIR)/plscan \
	$(BINDIR)/plsort \
	$(BINDIR)/pl_check_input \
	$(BINDIR)/pl_calc_bounds \
	$(BINDIR)/pl_mark_directions \
	$(BINDIR)/pl_match_ports_to_components \
	$(BINDIR)/pl_assign_pipe_numbers_to_inputs \
	$(BINDIR)/pl_assign_pipe_numbers_to_outputs \
	$(BINDIR)/pl_assign_fds \
	$(BINDIR)/pl_emit

BOOTSTRAP_GSH=$(BINDIR)/pl_bootstrap.gsh
DIAGRAM=pl_vsh.graphml
REGRESS-COMPILER=pl_dia_regression_compiler.gsh
PL_COMMON=../common/head.pl ../common/tail.pl

all : misc $(BOOTSTRAP_GSH) $(PL_COMMON)

regression : all $(BOOTSTRAP_GSH)
	$(BINDIR)/grash $(BOOTSTRAP_GSH) $(DIAGRAM) >$(REGRESS-COMPILER)
	sleep 1  # need to wait for the network to die down
	diff -q $(BOOTSTRAP_GSH) $(REGRESS-COMPILER)

execs : misc $(EXECS)

clean:
	rm -f $(EXECS) $(BOOTSTRAP_GSH) misc $(REGRESS-COMPILER) $(DIA-COMPILER)
	rm -f *.pro

cleanfb:
	rm -f *.pro

$(BINDIR)/% : %.pl $(PL_COMMON)
	gplc $< --output $@ --no-top-level

$(BINDIR)/plscan : plscan.lisp io.lisp
	buildapp --output $@ --load io.lisp --load plscan.lisp --entry main

misc : 
	mkdir -p $(BINDIR)
	echo "#!/bin/sh" >$(BINDIR)/plsort
	echo "sort" >>$(BINDIR)/plsort
	chmod a+x $(BINDIR)/plsort
	touch misc

bootstrap : $(BOOTSTRAP_GSH)

$(BOOTSTRAP_GSH) : $(DIAGRAM) $(EXECS)
	$(BINDIR)/plscan $(DIAGRAM) >0.pro
	$(BINDIR)/plsort <0.pro >1.pro
	$(BINDIR)/pl_check_input <1.pro >2.pro
	$(BINDIR)/pl_calc_bounds <2.pro >3.pro
	$(BINDIR)/pl_mark_directions <3.pro >4.pro
	$(BINDIR)/pl_match_ports_to_components <4.pro >5.pro
	$(BINDIR)/pl_assign_pipe_numbers_to_inputs <5.pro >6.pro
	$(BINDIR)/pl_assign_pipe_numbers_to_outputs <6.pro >7.pro
	$(BINDIR)/pl_assign_fds <7.pro >8.pro
	$(BINDIR)/plsort <8.pro >9.pro
	$(BINDIR)/pl_emit <9.pro >$(BOOTSTRAP_GSH)

