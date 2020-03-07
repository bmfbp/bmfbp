(in-package :arrowgrams)

(defclass runtime/part ()
  ((kind :accessor kind :initarg :kind)
   (input-queue :accessor input-queue :initform nil)
   (output-queue :accessor output-queue :initform nil)
   (parts :accessor parts :initform (make-hash-table :test 'equal))
   (parent :accessor parent :initarg :parent)))

