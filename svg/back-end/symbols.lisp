(in-package :arrowgrams/compiler/back-end)

; (:code symbols (:token) (:request :out :error) #'symbols-react #'symbols-first-time)

(defparameter *symbols-buffer* nil)
(defparameter *symbols-position* 0)
(defparameter *symbols-state* :idle)

(defun clear-buffer (pos)
  (setf *symbols-buffer* nil)
  (setf *symbols-position* pos))

(defun push-char-into-buffer (c)
  (push c *symbols-buffer*))

(defun get-buffer () (coerce (reverse *symbols-buffer*) 'string))
(defun get-position () *symbols-position*)

(defmethod symbols-first-time ((self e/part:part))
  (setf *symbols-state* :idle)
  )

(defmethod symbols-react ((self e/part:part) (e e/event:event))
  (flet ((new-symbol ()
           (let ((new-token (make-token :kind :symbol :text (get-buffer) :position (get-position))))
             new-token))
         (pull () (send! self :request t))
         (forward-token ()
           (send-event! self :out e)))
  (ecase *symbols-state*
    (:idle
     (ecase (e/event::sym e)
       (:token
        (let ((tok (e/event:data e)))
          (cond ((eq :character (token-kind tok))
                 (let ((c (token-text tok)))
                   (if (or (and (char>= c #\A) (char<= c #\Z))
                           (and (char>= c #\a) (char<= c #\z)))
                       (progn
                         (clear-buffer (token-position tok))
                         (push-char-into-buffer c)
                         (pull)
                         (setf *symbols-state* :collecting-symbol))
                     (forward-token))))
                (t (forward-token)))))))
    (:collecting-symbol
        (let ((tok (e/event:data e)))
          (cond ((eq :character (token-kind tok))
                 (let ((c (token-text tok)))
                   (if (or (and (char>= c #\A) (char<= c #\Z))
                           (and (char>= c #\a) (char<= c #\z))
                           (and (char>= c #\0) (char<= c #\9)))
                       (progn
                         (push-char-into-buffer c)
                         (pull))
                     (progn
                       (let ((str-token (new-symbol)))
                         (clear-buffer (token-position tok))
                         (send! self :out str-token)
                         (forward-token)
                         (setf *symbols-state* :idle))))))
                (t (forward-token))))))))
     

     
