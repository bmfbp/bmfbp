#+nil (ql:quickload :paip-lisp)

(<- (p 1))
(<- (p 2))
(<- (p 3))

;; this should give three values for ?x, hitting semi-colon to generate each one
;; when you hit semi-colon too many times (3, I think), it answers No. (no more solutions)
(defun cl-user::test ()
  (?- (p ?x)))


;; questions:
;; are <- and ?- in package :paip?  
;; should I qualify <- and ?- with packages?
