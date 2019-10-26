(in-package :paip)

(defun try ()
  
;;;   (with-open-file (f (asdf:system-relative-pathname :arrowgram/prolog-peg "temp.lisp") :direction :input)
;;;     (@:loop
;;;       (let ((clause (read f nil 'EOF)))
;;;         (@:exit-when (eq 'EOF clause))
;;;         (paip::add-clause (list clause))))

 ;; forward refs - need to compile some functions before others  (paip::prolog-compile-symbols '(ConditionalCreateEllispBB))
 (paip::prolog-compile-symbols '(condrect condspeech condtext))
 (paip::prolog-compile-symbols '(createboundingboxes))

 (paip::prolog-compile-symbols)
  ;(paip::?- (calc_bounds_main))
 (calc_bounds_main/0 #'paip::ignore))
