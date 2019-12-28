(in-package :arrowgrams/prolog-peg)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl-peg:into-package "ARROWGRAMS/PROLOG-PEG"))


(defparameter *test* "testRect :-
    forall(rect(ID), createRectBoundingBox(ID)).
condRect :-
    true.")

(defparameter *grammars* (list
                          *peg-rules-original*
                          *peg-rules-refactored*
                          *peg-rules-generic*
                          *peg-rules-hprolog*))

(defun deleter-p (x)
  (or (null x)
      (and (listp x)
           (null (car x))
           (null (cdr x)))))

(defun all (&optional (index 3))
  (let ((g (cl-peg:fullpeg (nth index *grammars*))))
    (mapc #'(lambda (r) 
              (eval r)) 
          (cdr g))
    (esrap:trace-rule 'arrowgrams/prolog-peg::pProgram :recursive t)
    (let ((parsed (esrap:parse 'arrowgrams/prolog-peg::pProgram *test*)))
    ;(let ((parsed (esrap:parse 'arrowgrams/prolog-peg::pProgram *all-prolog*)))
      (let ((parsed2
             (delete nil (mapcar #'(lambda (x)
                                     (if (and (listp x) (eq :rule (car x)))
                                         (delete-if #'deleter-p x)
                                       x))
                                 parsed))))
        parsed2))))

(defun dont-care-p (x)
  (string= "_" (symbol-name x)))