(in-package :arrowgrams/compiler)

(defclass spaces (e/part:code)
  ((buffer :accessor buffer)
   (state :accessor state)
   (nposition :accessor nposition)
   (nline :accessor nline)
   (start-position :accessor start-position)
   (start-line :accessor start-line)))

; (:code spaces (:token) (:pull :out :error))


(defmethod e/part:first-time ((self spaces))
  (setf (buffer self) nil)
  (setf (state self) :idle)
  (setf (nposition self) 0)
  (setf (nline self) 0))

(defmethod e/part:react ((self spaces) (e e/event:event))
  ;(format *standard-output* "~&spaces gets ~S ~S~%" (@pin self e) (@data self e))
  (labels ((push-char-into-buffer () 
	     (push (token-text (@data self e)) (buffer self)))
           (pull () (@send self :pull :spaces))
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
                 (member c '(#\Space #\Newline #\Tab #\Page)))))
           (follow-char-p ()
             (when (eq :character (token-kind (@data self e)))
               (let ((c (token-text (@data self e))))
                 (member c '(#\Space #\Newline #\Tab #\Page)))))
           (record ()
             (setf (nline self) (token-line (@data self e))
                   (nposition self) (token-position (@data self e))))
           (action () (@pin self e))
           (next-state (x) (setf (state self) x))
           (eof-p () (eq :eof (token-kind (@data self e))))
           (clear-buffer ()
	     (setf (buffer self) nil)
	     (setf (nposition self) (token-position (@data self e))))
           (release-buffer ()
             (@send self :out (make-token :kind :ws :text " " :position (start-position self) :line (start-line self) :pulled-p t)))
           (release-and-clear-buffer ()
             (release-buffer)
             (clear-buffer)))

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
                 (push-char-into-buffer)
                 (pull)
                 (next-state :collecting-ws))
		(t (forward-token))))))
      (:collecting-ws
       (ecase (action)
         (:token
          (record)
          (cond ((eof-p)
                 (release-and-clear-buffer)
                 (forward-token)
                 (next-state :done))
		((follow-char-p)
                 (push-char-into-buffer)
                 (pull))
		(t
		 (release-and-clear-buffer)
		 (forward-token)
                 (next-state :idle))))))
      (:done
       (@send self :error (format nil "spaces finished, but received ~S" e))))))

(defmethod e/part:busy-p ((self spaces))
  (call-next-method))
