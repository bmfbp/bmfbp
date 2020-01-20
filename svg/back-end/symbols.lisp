(in-package :arrowgrams/compiler/back-end)

; (:code symbols (:token) (:request :out :error) #'symbols-react #'symbols-first-time)

(defparameter *symbols-buffer* nil)
(defparameter *symbols-start-position* 0)
(defparameter *symbols-state* :idle)

(defun symbols-get-buffer () (coerce (reverse *symbols-buffer*) 'string))
(defun get-position () *symbols-start-position*)

(defmethod symbols-first-time ((self e/part:part))
  (setf *symbols-state* :idle)
  )

(defmethod symbols-react ((self e/part:part) (e e/event:event))
  (labels ((push-char-into-buffer () (push (token-text (e/event:data e)) *symbols-buffer*))
           (pull () (send! self :request t))
           (forward-token () (send-event! self :out e))
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
           (next-state (x) (setf *symbols-state* x))
           (eof-p () (eq :eof (token-kind (e/event:data e))))
           (clear-buffer ()
             (setf *symbols-buffer* nil)
             (setf *symbols-start-position* (token-position (e/event:data e))))
           (release-buffer ()
             (send! self :out (make-token :kind :symbol :text (symbols-get-buffer) :position (get-position))))
           (release-and-clear-buffer ()
             (release-buffer)
             (clear-buffer))
         )
    
    (ecase *symbols-state*
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
            nil)))))
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
                (forward-token)
                (next-state :idle)))))))
      (:done
       (send! self :error (format nil "symbols finished, but received ~S" e))))))
      
