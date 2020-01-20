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
  (labels ((pull () (send! self :request t))
         (forward-token ()
           (send-event! self :out e))
         (release-buffer ()
           (let ((ws-token (make-token :kind :ws :text (get-buffer) :position (get-position))))
             (clear-buffer (token-position (e/event::data e)))
             (send! self :out ws-token)
             (forward-token)
             (setf *ws-state* :idle))))
    (let ((tok (e/event:data e)))
      (ecase *ws-state*
        (:idle
         (ecase (e/event::sym e)
           (:token
            (format *standard-output* "~&ws :idle kind=~s pos=~s text=~s~%" (token-kind tok) (token-position tok) (token-text tok))
            (cond ((eq :character (token-kind tok))
                   (let ((c (token-text tok)))
                     (case c
                       ((#\Space #\Newline)
                        (clear-buffer (token-position tok))
                        (push-char-into-buffer c)
                        (setf *ws-state* :collecting-spaces)
                        (pull))
                       (otherwise (forward-token)))))
                  (t (forward-token))))))
        (:collecting-spaces
         (format *standard-output* "~&ws :collecting kind=~s pos=~s text=~s~%" (token-kind tok) (token-position tok) (token-text tok))
         (cond ((eq :character (token-kind tok))
                (let ((c (token-text tok)))
                  (case c
                    ((#\Space #\Newline)
                     (push-char-into-buffer c)
                     (pull))
                    (otherwise
                     (release-buffer)))))
               (t (release-buffer))))))))
     

     
