(in-package :arrowgrams/compiler)

(defclass synchronizer (e/part:part) ())
(defmethod e/part:busy-p ((self synchronizer)) (call-next-method))
; (:code synchronizer (:ir :json-filename :generic-filename :lisp-filename)
;                     (:ir :json-filename :generic-filename :lisp-filename :error)
;                     #'BE:e/part:react #'BE:e/part:first-time)

(defmethod e/part:first-time ((self synchronizer))
  (@set self :state :idle)
  (@set self :json-filename nil)
  (@set self :generic-filename nil)
  (@set self :lisp-filename nil)
  (@set self :ir nil))

(defmethod e/part:react ((self synchronizer) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (flet ((run-if-ready () ;; example of dataflow where all inputs must be satisfied before proceeding
             (when (and (@get self :ir)
                        (@get self :json-filename)
                        (@get self :generic-filename)
                        (@get self :lisp-filename))
               (@set self :state :running)
               (@send self :json-filename (@get self :json-filename))
               (@send self :generic-filename (@get self :generic-filename))
               (@send self :lisp-filename (@get self :lisp-filename))
               (@send self :ir (@get self :ir))
               (@set self :state :done))))
      (format *standard-output* "synchronizer gets ~A~%" pin)
      (ecase (@get self :state)
        (:idle
         (ecase pin
           (:ir (@set self :ir (e/event:data e))
            (run-if-ready))
           (:json-filename (@set self :json-filename (e/event:data e))
            (run-if-ready))
           (:generic-filename (@set self :generic-filename (e/event:data e))
            (run-if-ready))
           (:lisp-filename (@set self :lisp-filename (e/event:data e))
            (run-if-ready))))
         
         (:done
          (@send
           self :error
           (format nil "synchronizer in state :done expected <nothing>, but got action ~S data ~S" pin (e/event:data e))))))))
