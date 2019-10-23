(in-package :paip)

(defun try ()
  (with-open-file (f (asdf:system-relative-pathname :arrowgram/prolog-peg "temp.lisp") :direction :input)
    (@:loop
      (let ((clause (read f nil 'EOF)))
        (@:exit-when (eq 'EOF clause))
        (paip::add-clause (list clause))))
    (paip::?- (calc_bounds_main))))
