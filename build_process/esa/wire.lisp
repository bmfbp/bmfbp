(in-package :arrowgrams)

;======  class definition/part-pin ======

(defclass definition/part-pin () {
  ((part :accessor part :initarg :part)
   (pin  :accessor pin  :initarg :pin)))


;======  class definition/wire ======

;; the compiler(s) must ensure that all possible destinations for a given source are lumped
;; together in exactly one wire

(defclass definition/wire ()
  ((source :accessor source)
   (destinations :accessor destinations :initform nil)))

(defgeneric definition/set-source (wire part-pin))

(defgeneric definition/add-destination (wire part-pin))

(defgeneric query/get-source (wire))

(defgeneric query/get-destinations (wire))
