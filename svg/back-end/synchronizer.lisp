(in-package :arrowgrams/compiler/back-end)

; (:code synchronizer (:ir :json-filename :generic-filename :lisp-filename)
;                     (:ir :json-filename :generic-filename :lisp-filename :error)
;                     #'BE:synchronizer-react #'BE:synchronizer-first-time)

(defmethod synchronizer-first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle)
  (cl-event-passing-user::@set-instance-var self :json-filename nil)
  (cl-event-passing-user::@set-instance-var self :generic-filename nil)
  (cl-event-passing-user::@set-instance-var self :lisp-filename nil)
  (cl-event-passing-user::@set-instance-var self :ir nil))

(defmethod synchronizer-react ((self e/part:part) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (flet ((run-if-ready () ;; example of dataflow where all inputs must be satisfied before proceeding
             (when (and (cl-event-passing-user:@get-instance-var self :ir)
                        (cl-event-passing-user:@get-instance-var self :json-filename)
                        (cl-event-passing-user:@get-instance-var self :generic-filename)
                        (cl-event-passing-user:@get-instance-var self :lisp-filename))
               (cl-event-passing-user:@set-instance-var self :state :running)
               (cl-event-passing-user:@send self :json-filename (cl-event-passing-user:@get-instance-var self :json-filename))
               (cl-event-passing-user:@send self :generic-filename (cl-event-passing-user:@get-instance-var self :generic-filename))
               (cl-event-passing-user:@send self :lisp-filename (cl-event-passing-user:@get-instance-var self :lisp-filename))
               (cl-event-passing-user:@send self :ir (cl-event-passing-user:@get-instance-var self :ir))
               (cl-event-passing-user:@set-instance-var self :state :done))))
      (format *standard-output* "synchronizer gets ~A~%" pin)
      (ecase (cl-event-passing-user::@get-instance-var self :state)
        (:idle
         (ecase pin
           (:ir (cl-event-passing-user:@set-instance-var self :ir (e/event:data e))
            (run-if-ready))
           (:json-filename (cl-event-passing-user:@set-instance-var self :json-filename (e/event:data e))
            (run-if-ready))
           (:generic-filename (cl-event-passing-user:@set-instance-var self :generic-filename (e/event:data e))
            (run-if-ready))
           (:lisp-filename (cl-event-passing-user:@set-instance-var self :lisp-filename (e/event:data e))
            (run-if-ready))))
         
         (:done
          (cl-event-passing-user::@send
           self :error
           (format nil "synchronizer in state :done expected <nothing>, but got action ~S data ~S" pin (e/event:data e))))))))
