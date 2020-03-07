(in-package :arrowgrams)

(defclass dispatcher ()
  ((all-parts :accessor all-parts :initform nil)
   (top-part :accessor top-part :initform nil)))
