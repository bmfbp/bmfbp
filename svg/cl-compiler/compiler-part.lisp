(in-package :arrowgrams/compiler)

(defclass compiler-part (e/part:part) ())

(defmethod e/part:busy-p ((self compiler-part)) (call-next-method))

(defmethod e/part:first-time ((self compiler-part))
  (@set self :state :idle))

;; all compiler parts should inherit from compiler-part and implement (compiler-part-initially self), (compiler-part-run self event) and (compiler-part-name self)
(defgeneric compiler-part-intially (self))
(defgeneric compiler-part-run (self event))
(defgeneric compiler-part-name (self))

(defmethod e/part:first-time ((self compiler-part))
  (compiler-part-initially self))

(defmethod e/part:react ((self compiler-part) e)
  (compiler-part-run self e))
