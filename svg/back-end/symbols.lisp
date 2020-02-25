(in-package :arrowgrams/compiler)

(defclass symbols (compiler-part)
  ((buffer :accessor buffer)
   (start-position :accessor start-position)))

(defmethod e/part:busy-p ((self symbols)) (call-next-method))
; (:code symbols (:token) (:request :out :error) #'e/part:react #'e/part:first-time)

(defmethod symbols-get-buffer ((self symbols)) (coerce (reverse (buffer self)) 'string))
(defmethod symbols-get-position ((self symbols)) (start-position self))

(defmethod e/part:first-time ((self symbols))
  (setf (buffer self) nil)
  (setf (start-position self) 0)
  (call-next-method))

(defmethod e/part:react ((self symbols) (e e/event:event))
  (labels ((push-char-into-buffer () (push (token-text (e/event:data e)) (buffer self)))
           (pull () (@send self :request :symbols))
           (forward-token (&key (pulled-p nil)) (@send self :out (@data self e)))
           (start-char-p () 
             (when (eq :character (token-kind (e/event:data e)))
               (let ((c (token-text (e/event:data e))))
                 (or (and (char>= c #\A) (char<= c #\Z))
                     (and (char>= c #\a) (char<= c #\z))))))
           (follow-char-p ()
             (when (eq :character (token-kind (e/event:data e)))
               (let ((c (token-text (e/event:data e))))
                 (or (and (char>= c #\A) (char<= c #\Z))
                     (and (char>= c #\a) (char<= c #\z))
                     (and (char>= c #\0) (char<= c #\9))))))
           (action () (e/event::sym e))
           (next-state (x) (setf (state self) x))
           (eof-p () (eq :eof (token-kind (e/event:data e))))
           (clear-buffer ()
             (setf (buffer self) nil)
             (setf (start-position self) (token-position (e/event:data e))))
           (release-buffer ()
             (@send self :out (make-token :kind :symbol :text (symbols-get-buffer self) :position (symbols-get-position self) :pulled-p t)))
           (release-and-clear-buffer ()
             (release-buffer)
             (clear-buffer))
         )

    ;(format *standard-output* "~&symbols in state ~S gets ~S ~S~%" *symbols-state* (token-kind (e/event:data e)) (token-text (e/event:data e)))
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
                  (next-state :collecting-symbol))
              (forward-token))))))
      (:collecting-symbol
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
