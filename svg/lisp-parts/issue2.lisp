(ql:quickload :paip-lisp)


(<- (ok)
    (write "in ok"))

(<- (yes)
    (write "in yes"))

(<- (notok)
    (write "in notok"))

(<- (test1)
    (write "test1")
    (ok)
    (yes))

(<- (test2)
    (write "test2")
    (ok)
    !
    (notok))

(defun test ()
  (format *error-output* "~&starting test~%")
  (print (prove-all '((test1)) no-bindings))
  (print (prove-all '((test2)) no-bindings))
  (format *error-output* "~&ending test~%")
  (values))