(in-package :arrowgrams/compiler/back-end)

; (:code FILE-NAMER (:basename) (:json-filename :generic-filename :lisp-filename :error) #'BE:file-namer-react #'BE:file-namer-first-time)

(defmethod file-namer-first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle))

(defmethod file-namer-react ((self e/part:part) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (ecase (cl-event-passing-user::@get-instance-var self :state)
      (:idle
       (if (eq pin :basename)
           (let ((basename (e/event:data e)))
             (let ((jsonf (asdf:system-relative-pathname :arrowgrams/compiler (format nil "~a.json" basename)))
                   (genericf (asdf:system-relative-pathname :arrowgrams/compiler (format nil "~a.generic" basename)))
                   (lispf (asdf:system-relative-pathname :arrowgrams/compiler(format nil "~a.lisp" basename))))
             (cl-event-passing-user::@send self :json-filename jsonf)
             (cl-event-passing-user::@send self :generic-filename genericf)
             (cl-event-passing-user::@send self :lisp-filename lispf)))

           (cl-event-passing-user::@send self :error
                                         (format nil "file-namer in state :idle expected :basename, but got action ~S data ~S" pin (e/event:data e))))))))

