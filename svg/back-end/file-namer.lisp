(in-package :arrowgrams/compiler)

(defclass file-namer (e/part:code) ())

(defmethod e/part:busy-p ((self file-namer)) (call-next-method))

(defmethod e/part:clone ((self file-namer)) (call-next-method))

; (:code FILE-NAMER (:basename) (:json-filename :generic-filename :lisp-filename :error) #'BE:e/part:react #'BE:e/part:first-time)

(defmethod e/part:first-time ((self file-namer))
  (@set self :state :idle))

(defmethod e/part:react ((self file-namer) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (ecase (@get self :state)
      (:idle
       (if (eq pin :basename)
           (let ((basename (e/event:data e)))
             (let ((jsonf (asdf:system-relative-pathname :arrowgrams/compiler (format nil "svg/cl-compiler/~a.json" basename)))
                   (genericf (asdf:system-relative-pathname :arrowgrams/compiler (format nil "svg/cl-compiler/~a.generic" basename)))
                   (lispf (asdf:system-relative-pathname :arrowgrams/compiler(format nil "svg/cl-compiler/~a.lisp" basename))))
             (@send self :json-filename jsonf)
             (@send self :generic-filename genericf)
             (@send self :lisp-filename lispf)))

           (@send self :error
                                         (format nil "file-namer in state :idle expected :basename, but got action ~S data ~S" pin (e/event:data e))))))))

