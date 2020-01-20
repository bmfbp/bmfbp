(in-package :arrowgrams/compiler/back-end)

; (:code strings (:token) (:request :out :error) #'strings-react #'strings-first-time)

(defparameter *strings-buffer* nil)
(defparameter *strings-position* 0)
(defparameter *strings-state* :idle)

(defun symbols-clear-buffer (pos)
  (setf *strings-buffer* nil)
  (setf *strings-position* pos))

(defun symbols-push-char-into-buffer (c)
  (push c *strings-buffer*))

(defun symbols-get-buffer () (coerce (reverse *strings-buffer*) 'string))
(defun symbols-get-position () *strings-position*)

(defmethod strings-first-time ((self e/part:part))
  (setf *strings-state* :idle)
  )

(defmethod strings-react ((self e/part:part) (e e/event:event))
  (labels ((new-string () (make-token :kind :string :text (symbols-get-buffer) :position (symbols-get-position)))
           (check-eof ()
             (when (eq :eof (token-kind (e/event:data e)))
               (setf *strings-state* :done)))
           (pull () (send! self :request t))
           (forward-token () (send-event! self :out e)))
    ;(format *standard-output* "~&strings ~S ~S~%" *strings-state* (e/event:data e))
    (ecase *strings-state*
      (:idle
       (ecase (e/event::sym e)
         (:token
          (let ((tok (e/event:data e)))
            (cond ((eq :character (token-kind tok))
                   (let ((c (token-text tok)))
                     (case c
                       (#\"
                        (symbols-clear-buffer (token-position tok))
                        (symbols-push-char-into-buffer c)
                        (pull)
                        (setf *strings-state* :collecting-string))
                       (otherwise (forward-token)
                                  (check-eof)))))
                  (t
                   (forward-token)
                   (check-eof)))))))
      
      (:collecting-string
       (let ((tok (e/event:data e)))
         (cond ((eq :character (token-kind tok))
                (let ((c (token-text tok)))
                  (case c
                    (#\"
                     (symbols-push-char-into-buffer c)
                     (let ((str-token (new-string)))
                       (symbols-clear-buffer (token-position tok))
                       (send! self :out str-token)
                       (setf *strings-state* :idle)))
                    (otherwise
                     (symbols-push-char-into-buffer c)
                     (pull)))))
               ((eq :EOF (token-kind tok))
                (send! self :error (format nil "incomplete string at ~A" (symbols-get-position))))
               (t (assert nil)))))
      
      (:done
       (send! self :error (format nil "strings done, but received token ~S" (e/event:data e)))))))

        
     

     
