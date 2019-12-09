(in-package :arrowgrams/compiler)

(defun compiler ()
  (let ((compiler-net
          (cl-event-passing-user::@defnetwork compiler
           (:code reader (:file-name) (:out :eof :fatal) #'arrowgrams/compiler/reader::react)
           (:code fb (:string-fact :lisp-fact) (:done :fatal) #'arrowgrams/compiler/db::react #'arrowgrams/compiler/db::first-time)
           (:schem compiler (:file-name) (:out :fatal)
            ;; parts
            (reader fb)
            ;; wiring
            ((((:self :file-name)) ((reader :file-name)))
             (((reader :out)) ((fb :string-fact)))
             (((fb :done)) ((:self :out)))
             (((reader :fatal)) ((:self :fatal))))))))
    (e/dispatch::ensure-correct-number-of-parts 3) ;; not needed, except in early days of alpha debug, when everything is still in text form
    (cl-event-passing-user::@with-dispatch
      (let ((filename (asdf:system-relative-pathname :arrowgrams/compiler "svg/cl-compiler/temp5.pro")))
        (cl-event-passing-user::@inject compiler-net
                                        (e/part::get-input-pin compiler-net :file-name)
                                       filename)))))
