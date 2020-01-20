(in-package :arrowgrams/compiler/back-end)

; (:code ws (:token) (:request :out :error) #'ws-react #'ws-first-time)

(defparameter *ws-buffer* '(#\"))
(defparameter *ws-position* 0)
(defparameter *ws-state* :idle)

(defun clear-buffer (pos)
  (setf *ws-buffer* '(#\"))
  (setf *ws-position* pos))

(defun push-char-into-buffer (c)
  (push c *ws-buffer*))

(defun get-buffer () (coerce (reverse *ws-buffer*) 'string))
(defun get-position () *ws-position*)

(defmethod ws-first-time ((self e/part:part))
  (setf *ws-state* :idle)
  )

(defmethod ws-react ((self e/part:part) (e e/event:event))
  (flet ((new-ws () (make-token :kind :ws :text (get-buffer) :position (get-position)))
         (pull () (send! self :request t))
         (forward-token ()
           (send-event! self :out e)))
  (ecase *ws-state*
    (:idle
     (ecase (e/event::sym e)
       (:token
        (let ((tok (e/event:data e)))
          (cond ((eq :character (token-kind tok))
                 (let ((c (token-text tok)))
                   (case c
                     (#\Space
                      (clear-buffer (token-position tok))
                      (pull)
                      (setf *ws-state* :collecting-spaces))
                     (otherwise (forward-token)))))
                (t (forward-token)))))))
    (:collecting-spaces
        (let ((tok (e/event:data e)))
          (cond ((eq :character (token-kind tok))
                 (let ((c (token-text tok)))
                   (case c
                     (#\Space
                      (push-char-into-buffer c)
                      (let ((str-token (new-ws)))
                        (clear-buffer (token-position tok))
                        (send! self :out str-token)
                        (setf *ws-state* :idle)))
                     (otherwise
                      (push-char-into-buffer c)
                      (pull)))))
                (t (forward-token))))))))
     

     
