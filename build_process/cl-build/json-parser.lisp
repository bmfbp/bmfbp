(in-package :arrowgrams/build/cl-build)

(defparameter arrowgrams/build/cl-build/globals::*peg-parser* nil)
(defparameter arrowgrams/build/cl-build/globals::*json-source* nil)

(defun json-parser (peg-filename json-filename)
  ;; the only difference from above it "(parser-builder)" instead of "*parser-builder-net*"
  (let ((parser-builder-net (parser-builder))) ;; this call add parts to the dispatcher list
    (cl-event-passing-user::@initialize)       ;; this clears the dispatcher list
    (setf arrowgrams/build/cl-build/globals::*peg-parser* nil
           arrowgrams/build/cl-build/globals::*json-source* nil)
    (cl-event-passing-user::@enable-logging)
    (let ((net
           (cl-event-passing-user::@defnetwork 
            TOP
            (:part parser-builder-net pbuilder (:peg-source-file-name) (:lisp-source-out :fatal-error))
            (:code json-parser (:source-to-be-parsed :lisp-parser-source) (:lisp-source-out :fatal) #'parser-reactor)
            (:code readfile (:filename) (:out) #'arrowgrams/clparts::readfileintostring)
            (:code sq (:in) (:out) #'arrowgrams/clparts::stripquotes)
            (:schem TOP (:peg-source-file-name :json-source-file-name) (:lisp-source-out :fatal-error)
             (pbuilder json-parser) ;; internal parts
             ;; wiring
             ((((:self :peg-source-file-name)) ((pbuilder :peg-source-file-name)))
              (((:self :json-source-file-name)) ((readfile :filename)))

              (((pbuilder :lisp-source-out)) ((json-parser :lisp-parser-source)))
              
              (((json-parser :lisp-source-out)) ((:self :lisp-source-out)))

              (((readfile :out)) ((sq :in)))
              (((sq :out)) ((json-parser :source-to-be-parsed)))
               

              (((json-parser :fatal)) ((:self :fatal-error)))
              (((readfile :fatal)) ((:self :fatal-error)))
              (((sq :fatal)) ((:self :fatal-error)))
              (((pbuilder :fatal-error)) ((:self :fatal-error))))))))

      (e/dispatch::ensure-correct-number-of-parts (+ 2 2 4))  ;; early debug
      (let ((peg-in-pin (e/part::get-input-pin net :peg-source-file-name))
            (json-in-pin (e/part::get-input-pin net :json-source-file-name)))
        (cl-event-passing-user::@send net peg-in-pin peg-filename)
        (cl-event-passing-user::@send net json-in-pin json-filename)))))
  


(defmethod parser-reactor ((self e/part:code) (e e/event:event))
  (let ((pin (e/event::event-pin e)))
    (e/part::ensure-valid-input-pin self pin) ;; debug - ensure that event contains a valid pin id
    (ecase (e/event::event-pin e)
      (:lisp-parser-source
       (eval (e/event::data e))
       (setf arrowgrams/build/cl-build/globals::*peg-parser* t)
       (try-to-parse self))
      
      (:source-to-be-parsed
       (setf arrowgrams/build/cl-build/globals::*json-source* (e/event::data e))
       (try-to-parse self)))))

(defmethod try-to-parse ((self e/part:code))
  ;; parses IFF both inputs have arrived, otherwise does nothing (a standard pattern for state machines)
  (when (and
         arrowgrams/build/cl-build/globals::*peg-parser*
         arrowgrams/build/cl-build/globals::*json-source*)
    (let ((resulting-lisp (esrap:parse arrowgrams/build/cl-build/globals::*peg-parser*
                                       arrowgrams/build/cl-build/globals::*json-source*)))
      ;; peg parser is esrap-lisp that parses JSON and creates lisp code that mimics the JSON
      ;; send resulting lisp code to output pin
      (cl-event-passing-user::@send self :lisp-source-out resulting-lisp))))

      
     