(in-package :cl-user)

(defclass wire ()
(
(index :accessor index :initform nil)
(sources :accessor sources :initform nil)
(destinations :accessor destinations :initform nil)))
#| external method ((self wire)) install-source |#
#| external method ((self wire)) install-destination |#
(defmethod add-source ((self wire) part pin)
        (install-source self part pin))
(defmethod add-destination ((self wire) part pin)
        (install-destination self part pin))
