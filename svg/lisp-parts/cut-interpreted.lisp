(in-package :paip)

(<- (x 40))
(<- (y 50))

(defun test1 ()
  (?- (x ?X) (y ?Y)))  ; works, hit ';' once and get "No."

(defun test2 ()
  (?- (x ?X) ! (y ?Y)))  ; error (cannot take car of !)
