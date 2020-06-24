(in-package :arrowgrams/build)

(defclass file-writer (node)
  ((filename :accessor filename)))

(defmethod intially ((self file-writer))
  (setf (filename self) nil)
  (call-next-method))

(defmethod react ((self file-writer) (e e/event:event))
  (ecase (pin-name (part-pin e))

    (:filename
     (setf (filename self) (data e)))

    (:write
     (let ((str (data e)))
       (with-open-file (f (filename self) :direction :output :if-exists :supersede :if-does-not-exist :create)
	 (if (stringp str)
             (write-string str f)
	    (format f "~S" str)))))))
