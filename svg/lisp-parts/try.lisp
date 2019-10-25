(in-package :paip)

(defun try ()
  
;;;   (with-open-file (f (asdf:system-relative-pathname :arrowgram/prolog-peg "temp.lisp") :direction :input)
;;;     (@:loop
;;;       (let ((clause (read f nil 'EOF)))
;;;         (@:exit-when (eq 'EOF clause))
;;;         (paip::add-clause (list clause))))

  (paip::prolog-compile-symbols)  ;; compile of TOP_LEVEL_PROVE fails if calc_bounds/0 has not been compiled
  (paip::?- (calc_bounds_main)))
