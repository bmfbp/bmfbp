BINDIR=~/bin

EXECS = $(BINDIR)/d2json

all : $(EXECS)

$(BINDIR)/d2json: util.lisp toprolog.lisp fix-translate.lisp collapse-lines.lisp create-text-objects.lisp \
	            fix-arrows.lisp fix-lines.lisp main.lisp
	buildapp \
		--eval '(uiop:run-program "~/quicklisp/local-projects/rm.bash")' \
		--eval '(ql:quickload :sl)' \
		--eval '(ql:quickload :arrowgrams/build)' \
		--load main.lisp \
		--output $(BINDIR)/d2json \
		--entry main

# $(BINDIR)/fb_to_prolog: util.lisp toprolog.lisp fix-translate.lisp collapse-lines.lisp create-text-objects.lisp \
# 	            fix-arrows.lisp fix-lines.lisp main.lisp
# 	buildapp --output $(BINDIR)/fb_to_prolog \
# 		--load util.lisp \
# 		--load toprolog.lisp \
# 		--load fix-translate.lisp \
# 		--load collapse-lines.lisp \
# 		--load create-text-objects.lisp \
# 		--load fix-arrows.lisp \
# 		--load fix-lines.lisp \
# 		--load main.lisp \
# 		--entry main

# $(BINDIR)/unmap-strings: unmap-strings.lisp
# 	buildapp --output $(BINDIR)/unmap-strings \
# 		--load util.lisp \
# 		--load unmap-strings.lisp \
# 		--entry main

# $(BINDIR)/lib_insert_part_name: lib_insert_part_name.lisp
# 	buildapp --output $(BINDIR)/lib_insert_part_name --load lib_insert_part_name.lisp --entry main

# # for looking back at index-based pins (testing new version)
# $(BINDIR)/emit_js2: emit_js2.lisp
# 	buildapp --output $(BINDIR)/emit_js2 \
# 		--load util.lisp \
# 		--load emit_js2.lisp \
# 		--entry main

# $(BINDIR)/new_emit_js2: new_emit_js2.lisp
# 	buildapp --output $(BINDIR)/new_emit_js2 \
# 		--load util.lisp \
# 		--load new_emit_js2.lisp \
# 		--entry main

clean :
	rm -f $(EXECS)

