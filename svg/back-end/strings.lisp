(in-package :arrowgrams/compiler/back-end)

; (:code strings (:token) (:request :out :error) #'strings-react #'strings-first-time)

(defparameter *strings-buffer* nil)
(defparameter *strings-start-position* 0)

(defun strings-get-buffer () (coerce (reverse *strings-buffer*) 'string))
(defun strings-get-position () *strings-start-position*)

(defmethod strings-first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle)
  )

(defmethod strings-react ((self e/part:part) (e e/event:event))
  (labels ((push-char-into-buffer () (push (token-text (e/event:data e)) *strings-buffer*))
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
             (setf *strings-buffer* nil)
             (setf *strings-start-position* (token-position (e/event:data e))))
           (release-buffer ()
             (send! self :out (make-token :kind :string :text (strings-get-buffer) :position (strings-get-position))))
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

