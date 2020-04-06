(in-package :arrowgrams/build)

(defclass raw-text (node) ()  
  ((state :accessor state)
   (buffered-token :accessor buffered-token)))

(defmethod initially ((self raw-text))
  (setf (state self) :idle)
  (setf (buffered-token self) nil))

(defmethod react ((self raw-text) (e event))
  (machine
    (state :idle
       ("wrapup" send-buffer :next :done)
       ("token" :if dollar? :then reset-buffer :next :collecting :else pass-through)
       (t (internal-error)))
    (state :collecting
       ("wrapup" send-buffer :next :done)
       ("token" :if newline? :then send-buffer reset-buffer :next :idle :else pass-through)
       (t (internal-error)))
    (state :done
       (t (internal-error)))))


  (ecase (state self)
    (:idle
     (let ((tok (data e)))
       (if (and (eq :character (token-kind tok))
		(char= #\$ (token-text tok)))
	   (progn
	     (reset-buffer self)
	     (setf (state self) :collecting))
	   (send-event self "out" tok))))
    (:collecting
     (let ((tok (data e)))
       (if (and (eq :character (token-kind tok))
		(char= #\Newline (token-text tok)))
	   (progn
	     (reset-buffer self)
	     (setf (state self) :collecting))
	   (send-event self "out" tok))))
     
