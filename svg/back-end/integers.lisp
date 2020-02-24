(in-package :arrowgrams/compiler)

(defclass integers (e/part:code) ())
(defmethod e/part:busy-p ((self integers)) (call-next-method))
; (:code integers (:token) (:request :out :error) #'e/part:react #'e/part:first-time)

(defparameter *integers-buffer* nil)
(defparameter *integers-start-position* 0)
(defparameter *integers-state* :idle)
(defparameter *integers-token-pulled-p* nil)

(defun integers-get-buffer () (coerce (reverse *integers-buffer*) 'string))
(defun integers-get-position () *integers-start-position*)

(defmethod e/part:first-time ((self integers))
  (setf *integers-state* :idle))

(defmethod e/part:react ((self integers) (e e/event:event))
  (labels ((push-char-into-buffer () (push (token-text (e/event:data e)) *integers-buffer*))
           (pull () (@send self :request :integers))
           (forward-token (&key (pulled-p nil)) (@send self :out (@data self e)))
           (start-char-p () 
             (when (eq :character (token-kind (e/event:data e)))
               (let ((c (token-text (e/event:data e))))
                 (and (char>= c #\0) (char<= c #\9)))))
           (follow-char-p ()
             (when (eq :character (token-kind (e/event:data e)))
               (let ((c (token-text (e/event:data e))))
                 (and (char>= c #\0) (char<= c #\9)))))
           (action () (e/event::sym e))
           (next-state (x) (setf *integers-state* x))
           (eof-p () (eq :eof (token-kind (e/event:data e))))
           (clear-buffer ()
             (setf *integers-buffer* nil)
             (setf *integers-start-position* (token-position (e/event:data e))))
           (release-buffer ()
             (@send self :out (make-token :kind :integer :text (integers-get-buffer) :position (integers-get-position) :pulled-p t)))
           (release-and-clear-buffer ()
             (release-buffer)
             (clear-buffer))
         )

    #+nil(format *standard-output* "~&integers in state ~S gets ~S ~S~%" *integers-state* (token-kind (e/event:data e)) (token-text (e/event:data e)))
    (ecase *integers-state*
      (:idle
       (ecase (action)
         (:token
          (if (eof-p)
              (progn
                (forward-token)
		(e/part:first-time self))
            (if (start-char-p)
                (progn
                  (push-char-into-buffer)
                  (pull)
                  (next-state :collecting-integer))
              (forward-token))))))
      (:collecting-integer
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
                (next-state :idle))))))))))


