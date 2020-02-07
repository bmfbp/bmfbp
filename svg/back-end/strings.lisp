(in-package :arrowgrams/compiler/back-end)

; (:code strings (:token) (:request :out :error) #'strings-react #'strings-first-time)

(defmethod strings-get-ordered-buffer ((self e/part:part))
  (coerce (reverse (cl-event-passing-user::@get-instance-var self :buffer))
          'string))

(defmethod strings-put-buffer ((self e/part:part) item)
  (let ((buffer (cl-event-passing-user::@get-instance-var self :buffer)))
    (cl-event-passing-user::@set-instance-var self :buffer (cons item buffer))))

(defmethod strings-get-position ((self e/part:part))
  (cl-event-passing-user::@get-instance-var self :start-position))

(defmethod strings-clear-buffer ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :buffer nil))

(defmethod strings-first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle)
  (cl-event-passing-user::@set-instance-var self :start-position 0)
  (strings-clear-buffer self)
  )

(defmethod strings-react ((self e/part:part) (e e/event:event))
  (labels ((push-char-into-buffer () (strings-put-buffer self (token-text (e/event:data e))))
           (pull () (send! self :request :strings))
           (forward-token () (send-event! self :out e))
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
           (next-state (x) (cl-event-passing-user::@set-instance-var self :state x))
           (eof-p () (eq :eof (token-kind (e/event:data e))))
           (clear-buffer ()
             (strings-clear-buffer self))
           (release-buffer ()
             (send! self :out (make-token :kind :string :text (strings-get-ordered-buffer self) :position (strings-get-position self))))
           (release-and-clear-buffer ()
             (release-buffer)
             (clear-buffer))
         )

    #+nil(format *standard-output* "~&strings in state ~S gets ~S ~S~%" (cl-event-passing-user::@get-instance-var self :state)
                 (token-kind (e/event:data e)) (token-text (e/event:data e)))
    (ecase (cl-event-passing-user::@get-instance-var self :state)
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
       (send! self :error (format nil "strings finished, but received ~S" e))))))

