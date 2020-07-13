(in-package :arrowgrams/build)

(defclass file-writer (builder)
  ((filename :accessor filename)))

(defmethod e/part:busy-p ((self file-writer)) (call-next-method))

(defmethod e/part:clone ((self file-writer)) (call-next-method))

(defmethod e/part:first-time ((self file-writer))
  (setf (filename self) nil)
  (call-next-method))

(defmethod e/part:react ((self file-writer) (e e/event:event))
  (ecase (e/event::sym e)

    (:filename
     (setf (filename self) (e/event::data e)))

    (:write
     (let ((str (e/event:data e)))
       (with-open-file (f (filename self) :direction :output :if-exists :supersede :if-does-not-exist :create)
	 (if (stringp str)
             (write-string str f)
	    (format f "~S" str)))))))

(defclass alist-writer (file-writer) () )
