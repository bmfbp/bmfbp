(in-package :arrowgrams/build)

(defclass once (e/part:code)
  ((once :accessor once)))

(defmethod e/part:busy-p ((self once))
  (call-next-method))

(defmethod e/part:clone ((self once))
  (call-next-method))

(defmethod e/part:first-time ((self once))
  (setf (once self) nil))

(defmethod e/part:react ((self once) e)
  (ecase (@pin self e)
    (:in
     (cond ((null (once self))
            (@send self :out T)
            (setf (once self) T))))))
