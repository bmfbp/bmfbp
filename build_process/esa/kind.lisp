(in-package :arrowgrams)

(defclass definition/node ()
  ((input-pins :accessor input-pins :initform (make-hash-table :test 'equal))
   (output-pins :accessor output-pins :initform (make-hash-table :test 'equal))
   (parts :accessor parts :initform (make-hash-table :test 'equal))
   (wires :accessor wires :initform nil)))

;; in this version, we are using OO to do as much work for us as possible
;; all prototypes must have methods "initially" and "react"
(defgeneric initially (proto))
(defgeneric react (proto))

;; instance variables are allocated by OO when the prototype class is sub-classed


;; definer methods (note that CL requires that self be explicitly given as a parameter)

(defgeneric add-input-pin (self name))
(defgeneric add-output-pin (self name))

(defgeneric add-named-part(self name part-kind))

(defgeneric add-wire(self w))
