(in-package :arrowgrams/build)

(defclass compiler (node)
  ((counter :accessor counter)))

(defmethod initially ((self compiler))
)

(defmethod react ((self compiler) (e event))
  (let ((pp (part-pin e)))
    (format *standard-output* "~&compiler ~s:~s:~s~%" (part-name pp) (pin-name pp) (data e))
    (assert (eq (name-in-container self) (part-name pp) ))
    (ecase (pin-name pp)
      (:in
       (let ((part-name (pathname-name (data e))))
	 #+nil(send-event self :out part-name))))))
;; todo: call the compiler
;(arrowgrams:compiler:compile-single input-filename output-filename)
