#|

inputs: [eof token]
outputs: [out]
vars: []

initially
    state = idle
end initially

react
  machine
    idle : on * : filter-eof($data)
    wrapping-up : 
      on token : send-token send-eof
  end machine
end react

method filter-eof (token)
  if token.kind == EOF then
    -> wrapping-up
  else
    token-to-peer <- token
  end if
end method

|#

(in-package :arrowgrams)


(defclass eof-appender (node) ()  
  ((state :accessor state)
   (saved-token :accessor saved-token)))

(defmethod initially ((self eof-appender))
  #|
    self.state = idle
    self.buffered_token = nil
  |#
  (setf (state self) :idle)
  (setf (buffered-token self) nil))

(defmethod react ((self eof-appender) (e event))
#|
  (state :idle
	 ("token" (filter-eof)))
|#
  (ecase (state self)
    
    (:idle
     (cond ((string= "token" (pin-name (partpin e)))
	    (filter-eof self e))
	   (t (illegal))))
    ))

;; mechanisms for above state machine
(defmethod filter-eof ((self eof-appender) (e event))
  (let ((tok (data e)))
    (if (eq :eof (token-kind tok))
	(progn
	  (send-event self "eof" t)
	  (send-event self "wrapup" t))
      (send-event self "token" tok)))

;; utilities

(defmethod send-event ((self buffer) pin-name data)
  (let ((e (make-instance 'event))
        (temp-pp (make-instance 'part-pin)))
    (setf (part-name temp-pp) (name-in-container self))
    (setf (pin-name temp-pp) pin-name)
    (setf (partpin e) temp-pp)
    (setf (data    e) data)
    (send self e)))
