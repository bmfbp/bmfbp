(in-package :arrowgrams/compiler)

(defclass tokenize (compiler-part)
  ((tposition :accessor tposition)
   (str-stream :accessor str-stream)))

(defmethod e/part:busy-p ((self tokenize)) (call-next-method))

(defmethod e/part:first-time ((self tokenize))
  (setf (tposition self) 0)
  (setf (str-stream self) nil)
  (call-next-method))

(defmethod e/part:react ((self tokenize) (e e/event:event))
  (ecase (state self)
    (:idle
     #+nil(format *standard-output* "~&tokenize in state idle gets :start~%") ;; see also format below
     (ecase (e/event::sym e)
       (:start
        (let ((str (alexandria:read-file-into-string (e/event:data e))))
	  (setf (str-stream self) (make-string-input-stream str))
	  (setf (tposition self) 0)
	  (setf (state self) :running)))
       (:ir
        (let ((str (write-to-string (e/event:data e))))
	  (setf (str-stream self) (make-string-input-stream str))
	  (setf (tposition self) 0)
	  (setf (state self) :running)))))

    (:running
     (ecase (e/event::sym e)
       (:pull
        #+nil(format *standard-output* "~&tokenize in state running gets :pull ~S~%" (e/event:data e))
        (let ((c (read-char (stream self) nil :EOF)))
          (incf (tposition self))
          (let ((reached-eof (eq :EOF c)))
            (let ((tok (make-token :position (tposition self)
				   :kind (if reached-eof :EOF :character) :text c)))
              (@send self :out tok)
              (when reached-eof
		(e/part:first-time self))))))))))

