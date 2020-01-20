(in-package :arrowgrams/compiler/back-end)

; (:code ws (:token) (:request :out :error) #'ws-react #'ws-first-time)

(defparameter *ws-buffer* nil)
(defparameter *ws-position* 0)
(defparameter *ws-state* :idle)

(defun clear-buffer (pos)
  (setf *ws-buffer* nil)
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
                     ((#\Space #\Newline)
                      (clear-buffer (token-position tok))
                      (push-char-into-buffer c)
                      (pull)
                      (setf *ws-state* :collecting-spaces))
                     (otherwise (forward-token)))))
                (t (forward-token)))))))
    (:collecting-spaces
        (let ((tok (e/event:data e)))
          (cond ((eq :character (token-kind tok))
                 (let ((c (token-text tok)))
                   (case c
                     ((#\Space #\Newline)
                      (push-char-into-buffer c)
                      (pull))
                     (otherwise
                      (let ((ws-token (new-ws)))
                        (clear-buffer (token-position tok))
                        (send! self :out ws-token)
                        (forward-token)
                        (setf *ws-state* :idle))))))
                (t (forward-token))))))))
     

     
