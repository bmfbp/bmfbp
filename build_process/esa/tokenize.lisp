(in-package :rephrase)

(defclass tokenize (e/part:code)
  ((nline :accessor nline)
   (nposition :accessor nposition)
   (state :accessor state)
   (stream :accessor stream)))

#+nil(defmethod initialize-instance :after ((self tokenize) &key)
       (format *error-output* "~&tokenize initialized~%"))

(defmethod e/part:first-time ((self tokenize))
  (setf (state self) :idle)
  (setf (nline self) 1)
  (setf (nposition self) 1))  

(defmethod e/part:react ((self tokenize) (e e/event:event))
  #+nil(format *standard-output* "~&tokenize in state ~s gets ~s ~s~%" (state self) (@pin self e) (@data self e))
  (ecase (state self)
    (:idle
     #+nil(format *standard-output* "~&tokenize ~S in state idle gets :start~%" self) ;; see also format below
     (ecase (@pin self e)
       (:start
        (let ((str (alexandria:read-file-into-string (e/event:data e))))
          (setf (stream self) (make-string-input-stream str))
          (setf (nposition self) 1)
          (setf (nline self) 1)
          (setf (state self) :running)))))
       
    (:running
     (ecase (@pin self e)
       (:pull
        #+nil(format *standard-output* "~&tokenize in state running gets :pull ~S~%" (@data self e))
        (let ((c (read-char (stream self) nil :EOF)))
          (incf (nposition self))
          (let ((reached-eof (eq :EOF c)))
            (unless reached-eof
              (when (char= #\newline c)
                (incf (nline self))
                (setf (nposition self) 1)))
            (let ((tok (make-token :position (nposition self)
                                   :line (nline self)
                                   :kind (if reached-eof :EOF :character)
                                   :text c
                                   :pulled-p nil)))
              (@send self :out tok)
              (when reached-eof
                (setf (state self) :done))))))))
       
       (:done
	(@send self :error (format nil "tokenizer done, but received ~S ~S" (@pin self e) (@data self e))))))

(defmethod e/part:busy-p ((self tokenize))
  (call-next-method))
