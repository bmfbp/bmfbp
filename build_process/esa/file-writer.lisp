(in-package :rephrase)

(defclass file-writer (e/part:code)
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
       (assert (stringp str))
       (with-open-file (f (filename self) :direction :output :if-exists :supersede :if-does-not-exist :create)
         (write-string str f))))))
