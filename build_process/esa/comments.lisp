(in-package :arrowgrams/build)

(defclass comments (e/part:code)
  ((buffer :accessor buffer)
   (state :accessor state)
   (nposition :accessor nposition)
   (nline :accessor nline)
   (start-position :accessor start-position)
   (start-line :accessor start-line)))
   

; (:code comments (:token) (:pull :out :error))


(defmethod e/part:first-time ((self comments))
  (setf (buffer self) nil)
  (setf (state self) :idle)
  (setf (nposition self) 0)
  (setf (nline self) 0))

(defmethod e/part:react ((self comments) (e e/event:event))
  ;(format *standard-output* "~&comments gets ~S ~S~%" (@pin self e) (@data self e))
  (labels ((pull () (@send self :pull :comments))
           (forward-token (&key (pulled-p nil))
             (let ((tok (@data self e)))
               (let ((new-token (make-token :kind (token-kind tok)
                                            :text (token-text tok)
                                            :line (token-line tok)
                                            :position (token-position tok)
                                            :pulled-p (or pulled-p (token-pulled-p tok)))))
                 (@send self :out new-token))))
           (start-char-p () 
             (when (eq :character (token-kind (@data self e)))
               (let ((c (token-text (@data self e))))
                 (char= c #\%))))
           (follow-char-p ()
             (when (eq :character (token-kind (@data self e)))
               (let ((c (token-text (@data self e))))
                 (not (char= c #\Newline)))))
           (action () (@pin self e))
           (next-state (x) (setf (state self) x))
           (eof-p () (eq :eof (token-kind (@data self e))))
           (record ()
             (setf (nline self) (token-line (@data self e))
                   (nposition self) (token-position (@data self e))))
           (clear-buffer ()
	     (setf (buffer self) nil))
           (send-ws ()
             (@send self :out (make-token :kind :ws :text " " :position (start-position self) :line (start-line self) :pulled-p t))))

    (ecase (state self)
      (:idle
       (ecase (action)
         (:token
          (record)
          (cond ((eof-p)
                 (forward-token)
                 (next-state :done))
		((start-char-p)
                 (setf (start-position self) (nposition self))
                 (setf (start-line self) (nline self))
                 (pull)
                 (next-state :skipping-comment))
		(t (forward-token))))))
      (:skipping-comment
       (ecase (action)
         (:token
          (record)
          (cond ((eof-p)
                 (send-ws)
                 (forward-token)
                 (next-state :done))
		((follow-char-p)
                 (pull))
		(t
                 (send-ws)
		 ;(forward-token :pulled-p t)
		 (forward-token)
		 (next-state :idle))))))
      (:done
       (@send self :error (format nil "comments finished, but received ~S" e))))))

(defmethod e/part:busy-p ((self comments))
  (call-next-method))
