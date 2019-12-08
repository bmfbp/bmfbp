(in-package "LOOPS")

(defmacro loop (&body body) `(cl:loop ,@body))
(defmacro exit-when (test) `(cl:when ,test (cl:return)))


