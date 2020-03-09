(in-package :rephrase)

(defmacro parser-success-p (body)
  `(eq :ok ,body))

(defmacro parser-cond (&rest cond-bodies)
  ;; ( ((test) (...) (...)) ((test) (...) (...)) ... (t (...) (...)) )
  (rewrite-cond cond-bodies))

(defun rewrite-cond (cond-bodies)
  `(cond ,@(mapcar #'(lambda (test-and-body)
                       (let ((test (car test-and-body))
                             (body (rest test-and-body)))
                         (if (eq 'T test)
                             `(,test ,@body)
                           `((eq :ok ,test) ,@(rest test-and-body) :ok))))
                   cond-bodies)))


