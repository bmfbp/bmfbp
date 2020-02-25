(in-package :arrowgrams/compiler)

(defclass integers (compiler-part)
  ((buffer :accessor buffer)
   (start-position :accessor start-position)
   (ttoken-pulled-p :accessor ttoken-pulled-p)))

(defmethod e/part:busy-p ((self integers)) (call-next-method))
; (:code integers (:token) (:request :out :error) #'e/part:react #'e/part:first-time)

(defmethod integers-get-buffer ((self integers)) (coerce (reverse (buffer self)) 'string))
(defmethod integers-get-position ((self integers)) (start-position self))

(defmethod e/part:first-time ((self integers))
  (setf (buffer self) nil)
  (setf (start-position self) 0)
  (setf (ttoken-pulled-p self) nil)
  (call-next-method))

(defmethod e/part:react ((self integers) (e e/event:event))
  (labels ((push-char-into-buffer () (push (token-text (e/event:data e)) (buffer self)))
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
           (next-state (x) (setf (state self) x))
           (eof-p () (eq :eof (token-kind (e/event:data e))))
           (clear-buffer ()
             (setf (buffer self) nil)
             (setf (start-position self) (token-position (e/event:data e))))
           (release-buffer ()
             (@send self :out (make-token :kind :integer :text (integers-get-buffer self) :position (integers-get-position self) :pulled-p t)))
           (release-and-clear-buffer ()
             (release-buffer)
             (clear-buffer))
         )

    (ecase (state self)
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
                (next-state :idle))
            (if (follow-char-p)
                (progn
                  (push-char-into-buffer)
                  (pull))
              (progn
                (release-and-clear-buffer)
                (forward-token :pulled-p t)
                (next-state :idle))))))))))


