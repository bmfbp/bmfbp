(in-package :arrowgrams/compiler/back-end)

; (:code strings (:token) (:request :out :error) #'strings-react #'strings-first-time)

(defparameter *strings-buffer* nil)
(defparameter *strings-start-position* 0)
(defparameter *strings-state* :idle)

(defun strings-get-buffer () (coerce (reverse *strings-buffer*) 'string))
(defun strings-get-position () *strings-start-position*)

(defmethod strings-first-time ((self e/part:part))
  (setf *strings-state* :idle)
  )

(defmethod strings-react ((self e/part:part) (e e/event:event))
  (labels ((push-char-into-buffer () (push (token-text (e/event:data e)) *strings-buffer*))
           (pull () (send! self :request :strings) (format *standard-output* "~&strings pull~%"))
           (forward-token () (send-event! self :out e) (format *standard-output* "~&strings forwards token ~S ~S~%"
                                                               (e/event::sym e) (e/event::data e)))
           (start-char-p () 
             (when (eq :character (token-kind (e/event:data e)))
               (let ((c (token-text (e/event:data e))))
                 (char= c #\"))))
           (follow-char-p ()
             (when (eq :character (token-kind (e/event:data e)))
               (let ((c (token-text (e/event:data e))))
                 (not (char= c #\")))))
           (action () (e/event::sym e))
           (next-state (x) (setf *strings-state* x))
           (eof-p () (eq :eof (token-kind (e/event:data e))))
           (clear-buffer ()
             (setf *strings-buffer* nil)
             (setf *strings-start-position* (token-position (e/event:data e))))
           (release-buffer ()
             (format *standard-output* "~&strings release-buffer~%")
             (send! self :out (make-token :kind :string :text (strings-get-buffer) :position (strings-get-position))))
           (release-and-clear-buffer ()
             (release-buffer)
             (clear-buffer))
         )

    (format *standard-output* "~&strings in state ~S gets ~S ~S~%" *strings-state* (token-kind (e/event:data e)) (token-text (e/event:data e)))
    (ecase *strings-state*
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
                  (next-state :collecting-symbol))
              (forward-token))))))
      (:collecting-symbol
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
                (push-char-into-buffer)
                (release-and-clear-buffer)
                (next-state :idle)))))))
      (:done
       (send! self :error (format nil "strings finished, but received ~S" e))))))

