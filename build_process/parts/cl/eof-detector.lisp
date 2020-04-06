#|

inputs: [token]
outputs: [eof token wrapup]
vars: []

initially
    state = idle
end initially

react (e : event)
  machine
    idle : on * : filter-eof(data)
  end machine
end react

method filter-eof (token)
  if token.kind == EOF
    wrapup <- true
  else
    token-to-peer <- token
  end if
end method

  |#

(in-package :arrowgrams)


(defclass eof-detector (node) ()  
  ((state :accessor state)
   (saved-token :accessor saved-token)))

(defmethod initially ((self eof-detector))
  #|
    self.state = idle
    self.buffered_token = nil
  |#
  (setf (state self) :idle)
  (setf (buffered-token self) nil))

(defmethod react ((self eof-detector) (e event))
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
(defmethod filter-eof ((self eof-detector) (e event))
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
