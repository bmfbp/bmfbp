(in-package :arrowgrams/compiler/back-end)

; (:code file-writer (:token) (:out :error) #'file-writer-react #'file-writer-first-time)


(defmethod file-writer-first-time ((self e/part:part))
  )

(defmethod file-writer-react ((self e/part:part) (e e/event:event))
  (ecase (e/event::sym e)

    (:filename
     (cl-event-passing-user:@set-instance-var self :filename (e/event::data e)))

    (:write
     (let ((str (e/event:data e)))
       (assert (stringp str))
       (with-open-file (f (cl-event-passing-user:@get-instance-var self :filename) :direction :output :if-exists :supersede)
         (write-string str f))))))
