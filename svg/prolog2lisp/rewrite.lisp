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
