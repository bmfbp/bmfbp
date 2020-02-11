(in-package :arrowgrams/compiler)

(defclass file-writer (e/part:part) ())

(defclass generic-file-writer (file-writer) ())
(defclass json-file-writer (file-writer) ())
(defclass lisp-file-writer (file-writer) ())

(defmethod e/part:busy-p ((self file-writer)) (call-next-method))
; (:code file-writer (:token) (:out :error) #'e/part:react #'e/part:first-time)


(defmethod e/part:first-time ((self file-writer)))

(defmethod e/part:react ((self file-writer) (e e/event:event))
  (ecase (e/event::sym e)

    (:filename
     (@set self :filename (e/event::data e)))

    (:write
     (let ((str (e/event:data e)))
       (assert (stringp str))
       (with-open-file (f (@get self :filename) :direction :output :if-exists :supersede :if-does-not-exist :create)
         (write-string str f))))))
