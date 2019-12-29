(in-package :arrowgrams/prolog-peg)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl-peg:into-package "ARROWGRAMS/PROLOG-PEG"))


(defparameter *test* "testRect :-
    forall(rect(ID), createRectBoundingBox(ID)).
condRect :-
    true.")

(defparameter *true-test* "
createComments(_) :-
    asserta(log('fATAL',commentFinderFailed)),
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
  (init)
  (let ((g (cl-peg:fullpeg (nth index *grammars*))))
    (mapc #'(lambda (r) 
              (eval r)) 
          (cdr g))
    (let ((*target* *all-prolog*))
    ;(let ((*target* *true-test*))
      ;(esrap:trace-rule 'arrowgrams/prolog-peg::pProgram :recursive t)
    ;(let ((parsed (esrap:parse 'arrowgrams/prolog-peg::pProgram *test*)))
      (let ((parsed (esrap:parse 'arrowgrams/prolog-peg::pProgram (kill-foralls *target*))))
        (let ((parsed2
               (delete nil (mapcar #'(lambda (x)
                                       (if (and (listp x) (eq :rule (car x)))
                                           (delete-if #'deleter-p x)
                                         x))
                                   parsed))))
          parsed2)))))

(defun dont-care-p (x)
  (string= "_" (symbol-name x)))

(defun kill-foralls (in-str)
  (with-output-to-string (out-str)
    (with-input-from-string (str in-str)
      (@:loop
        (let ((line (read-line str nil 'EOF)))
          (@:exit-when (eq line 'EOF))
          (let ((success nil))
            (cl-ppcre:register-groups-bind (first second third fourth)
                (  "(forall.)(.+)([)])([,.])$"  line)
              (format out-str "~&~a~a %% ~a~a~a~a:)~%"
                      second fourth
                      first second third fourth)
              (setq success t))
            (unless success (format out-str "~a~%" line))))))
    out-str))

