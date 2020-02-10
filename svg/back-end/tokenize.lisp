(in-package :arrowgrams/compiler)

(defclass tokenize (e/part:part) ())

(defmethod e/part:busy-p ((self tokenize)) (call-next-method))

(defmethod e/part:first-time ((self tokenize))
  (@set self :state :idle)
  (@set self :position 0)
  (@set self :stream nil)
  (call-next-method))

(defmethod e/part:react ((self tokenize) (e e/event:event))
  (ecase (@get self :state)
    (:idle
     #+nil(format *standard-output* "~&tokenize in state idle gets :start~%") ;; see also format below
     (ecase (e/event::sym e)
       (:start
        (let ((str (alexandria:read-file-into-string (e/event:data e))))
	  (@set self :stream (make-string-input-stream str))
	  (@set self :position 0)
	  (@set self :state :running)))
       (:ir
        (let ((str (write-to-string (e/event:data e))))
	  (@set self :stream (make-string-input-stream str))
	  (@set self :position 0)
	  (@set self :state :running)))))

    (:running
     (ecase (e/event::sym e)
       (:pull
        #+nil(format *standard-output* "~&tokenize in state running gets :pull ~S~%" (e/event:data e))
        (let ((c (read-char (@get self :stream) nil :EOF)))
	  (@set self :position
						    (1+ (@get self :position)))
          (let ((reached-eof (eq :EOF c)))
          (let ((tok (make-token :position (@get self :position)
				 :kind (if reached-eof :EOF :character) :text c)))
            (@send self :out tok)
            (when reached-eof
	      (@set self :state :done))))))))

    (:done
     (@send self :error (format nil "tokenizer done, but received ~S ~S" (e/event::sym e) (e/event:data e)))))
  (call-next-method))
