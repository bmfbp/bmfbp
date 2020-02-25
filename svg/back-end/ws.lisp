(in-package :arrowgrams/compiler)

(defclass ws (compiler-part)
  ((buffer :accessor buffer)
   (tposition :accessor tposition)))

(defmethod e/part:busy-p ((self ws)) (call-next-method))
; (:code ws (:token) (:request :out :error) #'e/part:react #'e/part:first-time)

(defun clear-buffer (pos)
  (setf (buffer self) nil)
  (setf (tposition self) pos))

(defun push-char-into-buffer (c)
  (push c (buffer self)))

(defmethod get-buffer ((self ws)) (coerce (reverse (buffer self)) 'string))
(defmethod get-position ((self ws)) (tposition self))

(defmethod e/part:first-time ((self ws))
  (clear-buffer 0)
  (call-next-method))

(defmethod e/part:react ((self ws) (e e/event:event))
  (labels ((pull ()
             (@send self :request t))
           (check-eof ()
             (when (eq :eof (token-kind (e/event:data e)))
               (e/part:first-time self)))
           (forward-token () (@send self :out (@data self e)))
           (release-buffer ()
             (let ((ws-token (make-token :kind :ws :text (get-buffer self) :position (get-position self))))
               (clear-buffer (token-position (e/event::data e)))
               (@send self :out ws-token)
               (forward-token)
               (e/part:first-time self))))
    (let ((tok (e/event:data e)))
      (format *standard-output* "~&ws ~s kind=~s pos=~s text=~s~%" (state self) (token-kind tok) (token-position tok) (token-text tok)))
    (let ((tok (e/event:data e)))
      (ecase (state self)
        (:idle
         (ecase (e/event::sym e)
           (:token
            (cond ((eq :character (token-kind tok))
                   (let ((c (token-text tok)))
                     (case c
                       ((#\Space #\Newline)
                        (clear-buffer (token-position tok))
                        (push-char-into-buffer c)
                        (setf (state self) :collecting-spaces)
                        (pull)
                        (check-eof))
                       (otherwise (forward-token)))))
                  (t (forward-token) (check-eof))))))
        (:collecting-spaces
         ;(format *standard-output* "~&ws :collecting kind=~s pos=~s text=~s~%" (token-kind tok) (token-position tok) (token-text tok))
         (cond ((eq :character (token-kind tok))
                (let ((c (token-text tok)))
                  (case c
                    ((#\Space #\Newline)
                     (push-char-into-buffer c)
                     (pull)
                     (check-eof))
                    (otherwise
                     (release-buffer)
                     (check-eof)))))
               (t (release-buffer)
                  (check-eof))))))))
