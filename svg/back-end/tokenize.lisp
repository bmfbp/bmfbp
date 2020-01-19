(in-package :arrowgrams/compiler/back-end)

(defparameter *stream* nil)
(defparameter *position* 0)

(defmethod tokenize-first-time ((self e/part:part))
  )

(defmethod tokenize-react ((self e/part:part) (e e/event:event))
  (ecase (e/event::sym e)
    (:start
     (let ((str (alexandria:read-file-into-string (e/event:data e))))
       (setf *stream* (make-string-input-stream str))
       (setf *position* 0)))

    (:pull
     (let ((c (read-char *stream* nil :EOF)))
       (incf *position*)
       (let ((tok (make-token :position *position* :kind (if (eq :EOF c) :EOF :character) :text c)))
         (send! self :out tok))))))
