(in-package :arrowgrams/compiler)

(defclass strings (e/part:part) ())
(defmethod e/part:busy-p ((self strings)) (call-next-method))
; (:code strings (:token) (:request :out :error) #'e/part:react #'e/part:first-time)

(defmethod strings-get-ordered-buffer ((self strings))
  (coerce (reverse (@get self :buffer))
          'string))

(defmethod strings-put-buffer ((self strings) item)
  (let ((buffer (@get self :buffer)))
    (@set self :buffer (cons item buffer))))

(defmethod strings-get-position ((self strings))
  (@get self :start-position))

(defmethod strings-clear-buffer ((self strings))
  (@set self :buffer nil))

(defmethod e/part:first-time ((self strings))
  (@set self :state :idle)
  (@set self :start-position 0)
  (strings-clear-buffer self))

(defmethod e/part:react ((self strings) (e e/event:event))
  (labels ((push-char-into-buffer () (strings-put-buffer self (token-text (e/event:data e))))
           (pull () (@send self :request :strings))
           (forward-token () (@send self :out (@data self e)))
           (start-char-p () 
             (when (eq :character (token-kind (e/event:data e)))
               (let ((c (token-text (e/event:data e))))
                 (char= c #\"))))
           (follow-char-p ()
             (when (eq :character (token-kind (e/event:data e)))
               (let ((c (token-text (e/event:data e))))
                 (not (char= c #\")))))
           (escape-char-p ()
             (when (eq :character (token-kind (e/event:data e)))
               (let ((c (token-text (e/event:data e))))
                 (char= c #\\))))
           (action () (e/event::sym e))
           (next-state (x) (@set self :state x))
           (eof-p () (eq :eof (token-kind (e/event:data e))))
           (clear-buffer ()
             (strings-clear-buffer self))
           (release-buffer ()
             (@send self :out (make-token :kind :string :text (strings-get-ordered-buffer self) :position (strings-get-position self))))
           (release-and-clear-buffer ()
             (release-buffer)
             (clear-buffer))
         )

    #+nil(format *standard-output* "~&strings in state ~S gets ~S ~S~%" (@get self :state)
                 (token-kind (e/event:data e)) (token-text (e/event:data e)))
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
                  (next-state :collecting-string))
              (forward-token))))))
      (:collecting-string
       (ecase (action)
         (:token
          (if (eof-p)
              (progn
                (release-and-clear-buffer)
                (forward-token)
                (next-state :done))
            (if (escape-char-p)
                (progn
                  (next-state :escape)
                  (pull))
              (if (follow-char-p)
                  (progn
                    (push-char-into-buffer)
                    (pull))
                (progn
                  (push-char-into-buffer)
                  (release-and-clear-buffer)
                  (next-state :idle))))))))
      (:escape
       (ecase (action)
         (:token
          (if (eof-p)
              (progn
                (release-and-clear-buffer)
                (forward-token)
                (next-state :done))
            (progn
              (push-char-into-buffer)
              (pull)
              (next-state :collecting-string))))))
      (:done
       (@send self :error (format nil "strings finished, but received ~S" e))))))
