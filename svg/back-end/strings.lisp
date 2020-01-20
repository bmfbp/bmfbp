(in-package :arrowgrams/compiler/back-end)

; (:code strings (:token) (:request :out :error) #'strings-react #'strings-first-time)

(defparameter *strings-buffer* nil)
(defparameter *strings-position* 0)
(defparameter *strings-state* :idle)

(defun clear-buffer (pos)
  (setf *strings-buffer* nil)
  (setf *strings-position* pos))

(defun push-char-into-buffer (c)
  (push c *strings-buffer*))

(defun get-buffer () (coerce (reverse *strings-buffer*) 'string))
(defun get-position () *strings-position*)

(defmethod strings-first-time ((self e/part:part))
  (setf *strings-state* :idle)
  )

(defmethod strings-react ((self e/part:part) (e e/event:event))
  (flet ((new-string ()
           (let ((new-token (make-token :kind :string :text (get-buffer) :position (get-position))))
             new-token))
         (pull () (send! self :request t))
         (forward-token ()
           (send-event! self :out e)))
  (ecase *strings-state*
    (:idle
     (ecase (e/event::sym e)
       (:token
        (let ((tok (e/event:data e)))
          (cond ((eq :character (token-kind tok))
                 (let ((c (token-text tok)))
                   (case c
                     (#\"
                      (clear-buffer (token-position tok))
                      (push-char-into-buffer c)
                      (pull)
                      (setf *strings-state* :collecting-string))
                     (otherwise (forward-token)))))
                (t (forward-token)))))))
    (:collecting-string
        (let ((tok (e/event:data e)))
          (cond ((eq :character (token-kind tok))
                 (let ((c (token-text tok)))
                   (case c
                     (#\"
                      (push-char-into-buffer c)
                      (let ((str-token (new-string)))
                        (clear-buffer (token-position tok))
                        (send! self :out str-token)
                        (setf *strings-state* :idle)))
                     (otherwise
                      (push-char-into-buffer c)
                      (pull)))))
                ((eq :EOF (token-kind tok))
                 (send! self :error (format nil "incomplete string at ~A" (get-position))))
                (t (assert nil))))))))
     

     
