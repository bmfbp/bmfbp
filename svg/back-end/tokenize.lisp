(in-package :arrowgrams/compiler/back-end)

(defmethod tokenize-first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle)
  (cl-event-passing-user::@set-instance-var self :position 0)
  (cl-event-passing-user::@set-instance-var self :stream nil)
  )

(defmethod tokenize-react ((self e/part:part) (e e/event:event))
  (ecase (cl-event-passing-user::@get-instance-var self :state)
    (:idle
     #+nil(format *standard-output* "~&tokenize in state idle gets :start~%") ;; see also format below
     (ecase (e/event::sym e)
       (:start
        (let ((str (alexandria:read-file-into-string (e/event:data e))))
	  (cl-event-passing-user::@set-instance-var self :stream (make-string-input-stream str))
	  (cl-event-passing-user::@set-instance-var self :position 0)
	  (cl-event-passing-user::@set-instance-var self :state :running)))
       (:ir
        (let ((str (write-to-string (e/event:data e))))
	  (cl-event-passing-user::@set-instance-var self :stream (make-string-input-stream str))
	  (cl-event-passing-user::@set-instance-var self :position 0)
	  (cl-event-passing-user::@set-instance-var self :state :running)))))

    (:running
     (ecase (e/event::sym e)
       (:pull
        #+nil(format *standard-output* "~&tokenize in state running gets :pull ~S~%" (e/event:data e))
        (let ((c (read-char (cl-event-passing-user::@get-instance-var self :stream) nil :EOF)))
	  (cl-event-passing-user::@set-instance-var self :position
						    (1+ (cl-event-passing-user::@get-instance-var self :position)))
          (let ((reached-eof (eq :EOF c)))
          (let ((tok (make-token :position (cl-event-passing-user::@get-instance-var self :position)
				 :kind (if reached-eof :EOF :character) :text c)))
            (send! self :out tok)
            (when reached-eof
	      (cl-event-passing-user::@set-instance-var self :state :done))))))))

    (:done
     (send! self :error (format nil "tokenizer done, but received ~S ~S" (e/event::sym e) (e/event:data e))))))

    
