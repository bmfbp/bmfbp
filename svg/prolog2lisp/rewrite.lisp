(in-package :arrowgrams/prolog-peg)

(defun rewrite-clause (clause)
  clause)

#|
          (if (and (listp x)
                   (eq (first x) :inc)
                   (eq (second x) 'counter))
              `(lisp (inc-counter))
            (if (and (listp x)
                     (eq (first x) :dec)
                     (eq (second x) 'counter))
                `(lisp (dec-counter))
              (if (and (listp x)
                       (eq (first x) :g_assign)
                       (eq (second x) 'counter)
                       (eq (third x) 0))
                  `(lisp (clear-counter))
|#