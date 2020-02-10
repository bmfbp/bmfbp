(in-package :arrowgrams/compiler/back-end)

(defclass spaces (e/part:part) ())
(defmethod e/part:busy-p ((self spaces)) (call-next-method))

; (:code spaces (:token) (:request :out :error) #'e/part:react #'e/part:first-time)

(defmethod spaces-get-position ((self spaces))
  (@get self :position))

(defmethod e/part:first-time ((self spaces))
  (@set self :buffer nil)
  (@set self :state :idle)
  (@set self :position 0)
  (call-next-method))

(defmethod e/part:react ((self spaces) (e e/event:event))
  (labels ((push-char-into-buffer () 
	     (let ((buffer (@get self :buffer)))
	       (push (token-text (e/event:data e)) buffer)
	       (@set self :buffer buffer)))
           (pull () (@send self :request :spaces))
           (forward-token (&key (pulled-p nil)) (@send-event self :out e))
           (start-char-p () 
             (when (eq :character (token-kind (e/event:data e)))
               (let ((c (token-text (e/event:data e))))
                 (member c '(#\Space #\Newline #\Tab #\Page)))))
           (follow-char-p ()
             (when (eq :character (token-kind (e/event:data e)))
               (let ((c (token-text (e/event:data e))))
                 (member c '(#\Space #\Newline #\Tab #\Page)))))
           (action () (e/event::sym e))
           (next-state (x) (@set self :state x))
           (eof-p () (eq :eof (token-kind (e/event:data e))))
           (clear-buffer ()
	     (@set self :buffer nil)
	     (@set self :position (token-position (e/event:data e))))
           (release-buffer ()
             (@send self :out (make-token :kind :ws :text " " :position (spaces-get-position self) :pulled-p t)))
           (release-and-clear-buffer ()
             (release-buffer)
             (clear-buffer))
         )

    ;(format *standard-output* "~&spaces in state ~S gets ~S ~S~%" *spaces-state* (token-kind (e/event:data e)) (token-text (e/event:data e)))
    (ecase (@get self :state)
      (:idle
       (ecase (action)
         (:token
          (if (eof-p)
              (progn
                (forward-token)
                (next-state :done))
            (if (start-char-p)
                (progn
                  (push-char-into-buffer)
                  (pull)
                  (next-state :collecting-ws))
              (forward-token))))))
      (:collecting-ws
       (ecase (action)
         (:token
          (if (eof-p)
              (progn
                (release-and-clear-buffer)
                (forward-token)
                (next-state :done))
            (if (follow-char-p)
                (progn
                  (push-char-into-buffer)
                  (pull))
              (progn
                (release-and-clear-buffer)
                (forward-token :pulled-p t)
                (next-state :idle)))))))
      (:done
       (@send self :error (format nil "spaces finished, but received ~S" e)))))
  (call-next-method))
