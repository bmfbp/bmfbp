(in-package :arrowgrams/compiler/back-end)

(defparameter *tokenizer-stream* nil)
(defparameter *tokenizer-position* 0)
(defparameter *tokenizer-state* :idle)

(defmethod tokenize-first-time ((self e/part:part))
  )

(defmethod tokenize-react ((self e/part:part) (e e/event:event))
  (ecase *tokenizer-state*
    (:idle
     (ecase (e/event::sym e)
       (:start
        (let ((str (alexandria:read-file-into-string (e/event:data e))))
          (setf *tokenizer-stream* (make-string-input-stream str))
          (setf *tokenizer-position* 0)
          (setf *tokenizer-state* :running)))))

    (:running
     (ecase (e/event::sym e)
       (:pull
        (format *standard-output* "~&tokenize in state idle gets :pull ~S~%" (e/event:data e))
        (let ((c (read-char *tokenizer-stream* nil :EOF)))
          (incf *tokenizer-position*)
          (let ((reached-eof (eq :EOF c)))
          (let ((tok (make-token :position *tokenizer-position* :kind (if reached-eof :EOF :character) :text c)))
            (send! self :out tok)
            (when reached-eof
              (setf *tokenizer-state* :done))))))))

    (:done
     (send! self :error (format nil "tokenizer done, but received ~S" e)))))

    
