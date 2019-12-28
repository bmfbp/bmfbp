(in-package :arrowgrams/prolog-peg)

(defun rewrite-clause (clause)
  (format *standard-output* "~&rewrite clause /~S/~%" clause)
  (cond ((listp clause)
         (cond ((and (eq :g_assign (first clause))
                     (eq :counter (second clause))
                     (zerop (third clause)))
                `(:lisp (reset-counter)))
               ((and (eq :g_read (first clause))
                     (eq :counter (second clause)))
                `(:lispv ,(third clause) (read-counter)))
               
               #+nil((and (eq :is (first clause))
                     (listp (third clause))
                     (eq 'prolog:minus (first (third clause))))
                (let ((maybe-sym (second clause)))
                  (let ((vname (if (and (symbolp maybe-sym)
                                        (eq (find-package "KEYWORD") (symbol-package maybe-sym)))
                                   (intern (symbol-name maybe-sym))
                                 (second clause))))
                    `(:lispv ,vname ,@(rest (third clause))))))
               
               (t clause)))
        (t clause)))
  


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