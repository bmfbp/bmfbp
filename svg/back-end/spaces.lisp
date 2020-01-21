(in-package :arrowgrams/compiler/back-end)

; (:code spaces (:token) (:request :out :error) #'spaces-react #'spaces-first-time)

(defparameter *spaces-buffer* nil)
(defparameter *spaces-start-position* 0)
(defparameter *spaces-state* :idle)
(defparameter *spaces-token-pulled-p* nil)

(defun spaces-get-buffer () (coerce (reverse *spaces-buffer*) 'string))
(defun spaces-get-position () *spaces-start-position*)

(defmethod spaces-first-time ((self e/part:part))
  (setf *spaces-state* :idle)
  )

(defmethod spaces-react ((self e/part:part) (e e/event:event))
  (labels ((push-char-into-buffer () (push (token-text (e/event:data e)) *spaces-buffer*))
           (pull () (send! self :request :spaces))
           (forward-token (&key (pulled-p nil)) (send-event! self :out e))
           (start-char-p () 
             (when (eq :character (token-kind (e/event:data e)))
               (let ((c (token-text (e/event:data e))))
                 (member c '(#\Space #\Newline #\Tab #\Page)))))
           (follow-char-p ()
             (when (eq :character (token-kind (e/event:data e)))
               (let ((c (token-text (e/event:data e))))
                 (member c '(#\Space #\Newline #\Tab #\Page)))))
           (action () (e/event::sym e))
           (next-state (x) (setf *spaces-state* x))
           (eof-p () (eq :eof (token-kind (e/event:data e))))
           (clear-buffer ()
             (setf *spaces-buffer* nil)
             (setf *spaces-start-position* (token-position (e/event:data e))))
           (release-buffer ()
             (send! self :out (make-token :kind :ws :text " " :position (spaces-get-position) :pulled-p t)))
           (release-and-clear-buffer ()
             (release-buffer)
             (clear-buffer))
         )

    ;(format *standard-output* "~&spaces in state ~S gets ~S ~S~%" *spaces-state* (token-kind (e/event:data e)) (token-text (e/event:data e)))
    (ecase *spaces-state*
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
                  (next-state :collecting-ws))
              (forward-token))))))
      (:collecting-ws
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
                (next-state :idle)))))))
      (:done
       (send! self :error (format nil "spaces finished, but received ~S" e))))))

