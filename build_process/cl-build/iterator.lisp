(in-package :arrowgrams/build)

(defclass iterator (e/part:code)
  ((state :accessor state))

(defmethod e/part:busy-p ((self iterator))
  (call-next-method))

(defmethod e/part:clone ((self iterator))
  (call-next-method))

(defmethod e/part:first-time ((self iterator))
  (setf (state self) :idle))

(defmethod e/part:react ((self iterator) e)
  (ecase (state self)
    (:idle
     (ecase (@pin self e)
       (:start
        (cond (
            (@send self :out T)
            (setf (iterator self) T))))))
---- 

realization - we don't need this part, just loop :json-file-ref's back to compile-single-diagram
