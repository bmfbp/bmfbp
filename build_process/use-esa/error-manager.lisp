(in-package :arrowgrams/esa)

(defclass error-manager (e/part:code)
  ())

(defclass esa-error-manager (error-manager) ())

; (:code error-manager (:error) ()) 

(defmethod e/part:first-time ((self error-manager))
)

(defmethod e/part:react ((self error-manager) (e e/event:event))
  (error (format nil "error manager: ~s ~s" (@pin self e) (@data self e))))

(defmethod e/part:busy-p ((self error-manager))
  (call-next-method))
