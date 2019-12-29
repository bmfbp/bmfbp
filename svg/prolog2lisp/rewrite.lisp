(in-package :arrowgrams/prolog-peg)

(defun rewrite-clause (clause)
  (cond ((listp clause)
         (cond ((and (eq :g_assign (first clause))
                     (eq :counter (second clause))
                     (zerop (third clause)))
                `(:lisp (reset-counter)))
               ((and (eq :g_read (first clause))
                     (eq :counter (second clause)))
                `(:lispv ,(third clause) (read-counter)))
               
               ((or
                 (eq :g_assign (first clause))
                 (eq :g_read (first clause)))
                (format nil "(:lisp (assert nil (nil) \"was /~S/" clause))

               (t clause)))

        ((eq 'prolog:pl-true clause)
         `(:lisp t))

        ((eq 'prolog:pl-fail clause)
         `(:lisp nil))

        (t clause)))
  

(defun rewrite-op (op)
  (if (eq op 'prolog:plus)
      'cl:+
    (if (eq op 'prolog:minus)
        'cl:-
      (if (eq op 'prolog:mul)
          'cl:*
        (if (eq op 'prolog:div)
            'cl:/
          (error (format nil "expecting +,-,*,/, but got ~A" op)))))))
