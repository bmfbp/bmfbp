(in-package :arrowgrams/build)

(defclass part-namer (node)
  ((counter :accessor counter)))

(defmethod initially ((self part-namer))
)

(defmethod react ((self part-namer) (e event))
  (let ((pp (part-pin e)))
    (assert (eq (name-in-container self) (part-name pp) ))
    (ecase (pin-name e)
      (:in
       (let ((part-name (pathname-name (data e))))
	 (send-event self :out part-name))))))
