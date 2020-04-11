(in-package :arrowgrams/build)

(defclass stacker (e/part:code)
  ((stack :accessor stack)))

(defmethod e/part:busy-p ((self stacker))
  (call-next-method))

(defmethod e/part:clone ((self stacker))
  (call-next-method))

(defmethod e/part:first-time ((self stacker))
  (setf (stack self) nil))

(defmethod e/part:react ((self stacker) e)
  (ecase (@pin self e)
    (:pop
     (if (null (stack self))
         (@send self :nomore T)
       (@send self :item (pop (stack self)))))
    (:enstack
     (push (@data self e) (stack self)))))

    