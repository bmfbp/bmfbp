(in-package :paip)

(defun try ()
  (paip::clear-db)
  (build-temp)
  ;; we need to create forward refs 
  ;; need to compile some functions before others  (paip::prolog-compile-symbols '(ConditionalCreateEllispBB))
  (paip::prolog-compile-symbols '(condrect condspeech condtext))
  (paip::prolog-compile-symbols '(createboundingboxes))
  
  (paip::prolog-compile-symbols)
  ;(paip::?- (calc_bounds_main)) expands to the following line:
  (calc_bounds_main/0 #'paip::ignore))

(defun build-temp ()
  ;; run this only once to get the contents of "temp.lisp" converted to PAIP clauses in memory
  (with-open-file (f (asdf:system-relative-pathname :arrowgram/prolog-peg "temp.lisp") :direction :input)
    (@:loop
      (let ((clause (read f nil 'EOF)))
        (@:exit-when (eq 'EOF clause))
        (paip::add-clause (list clause))))))

  