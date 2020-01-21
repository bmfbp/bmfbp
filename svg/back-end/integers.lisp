(in-package :arrowgrams/compiler/back-end)

; (:code integers (:token) (:request :out :error) #'integers-react #'integers-first-time)

(defparameter *integers-buffer* nil)
(defparameter *integers-start-position* 0)
(defparameter *integers-state* :idle)
(defparameter *integers-token-special* nil)

(defun integers-get-buffer () (coerce (reverse *integers-buffer*) 'string))
(defun integers-get-position () *integers-start-position*)

(defmethod integers-first-time ((self e/part:part))
  (setf *integers-state* :idle)
  )

(defmethod integers-react ((self e/part:part) (e e/event:event))
  (labels ((push-char-into-buffer () (push (token-text (e/event:data e)) *integers-buffer*))
           (pull () (send! self :request :integers))
           (forward-token (&key (special nil))
             (if special
                 (let ((tok (e/event:data e)))
                   (send! self :out (make-token :kind (token-kind tok) :text (token-text tok) :position (token-position tok) :special nil)))
               (send-event! self :out e)))
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
             (send! self :out (make-token :kind :integer :text (integers-get-buffer) :position (integers-get-position) :special t)))
           (release-and-clear-buffer ()
             (release-buffer)
             (clear-buffer))
         )

    ;(format *standard-output* "~&integers in state ~S gets ~S ~S~%" *integers-state* (token-kind (e/event:data e)) (token-text (e/event:data e)))
    (ecase *integers-state*
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
                (release-and-clear-buffer)
                (forward-token :special t)
                (next-state :idle)))))))
      (:done
       (send! self :error (format nil "integers finished, but received ~S" e))))))

