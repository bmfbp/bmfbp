(in-package :arrowgrams/build/cl-build)

(cl-peg:into-package :arrowgrams/build/cl-build)

;; these should be instance variables...
(defparameter arrowgrams/build/cl-build/globals::*peg-parser* nil)
(defparameter arrowgrams/build/cl-build/globals::*pseudo-source* nil)
(defparameter arrowgrams/build/cl-build/globals::*debug-grammar* nil)
(defparameter arrowgrams/build/cl-build/globals::*grammar-name* nil)

(defun pseudo-parser (grammar-name peg-filename pseudo-filename &key (debug nil))
  ;; the only difference from above it "(parser-builder)" instead of "*parser-builder-net*"
  (let ((parser-builder-net (arrowgrams/clparts::parser-builder))) ;; this call add parts to the dispatcher list
    (cl-event-passing-user::@initialize)       ;; this clears the dispatcher list
    (setf arrowgrams/build/cl-build/globals::*peg-parser* nil
          arrowgrams/build/cl-build/globals::*pseudo-source* nil)
    (cl-event-passing-user::@enable-logging)
    (let ((net
           (cl-event-passing-user::@defnetwork 
            TOP
            (:part parser-builder-net pbuilder (:peg-source-file-name) (:lisp-source-out :fatal-error))
            (:code pseudo-parser (:grammar-name :debug-grammar :source-to-be-parsed :lisp-parser-source) (:pass2-source-out :fatal) #'pseudo-parser-reactor)
            (:code readfile (:filename) (:out :fatal) #'arrowgrams/clparts::readfileintostring)
            (:code sq (:in) (:out :fatal) #'arrowgrams/clparts::stripquotes)
            (:schem TOP (:peg-source-file-name :grammar-name :pseudo-source-file-name :debug-grammar) (:pass2-source-out :fatal-error)
             (pbuilder pseudo-parser sq readfile) ;; internal parts
             ;; wiring
             ((((:self :peg-source-file-name)) ((pbuilder :peg-source-file-name)))
              (((:self :grammar-name)) ((pseudo-parser :grammar-name)))
              (((:self :pseudo-source-file-name)) ((readfile :filename)))
              (((:self :debug-grammar)) ((pseudo-parser :debug-grammar)))
              
              (((pbuilder :lisp-source-out)) ((pseudo-parser :lisp-parser-source)))
              
              (((pseudo-parser :pass2-source-out)) ((:self :pass2-source-out)))
              
              (((readfile :out)) ((sq :in)))
              (((sq :out)) ((pseudo-parser :source-to-be-parsed)))
              
              
              (((pseudo-parser :fatal)) ((:self :fatal-error)))
              (((readfile :fatal)) ((:self :fatal-error)))
              (((sq :fatal)) ((:self :fatal-error)))
              (((pbuilder :fatal-error)) ((:self :fatal-error))))))))
      
      (e/dispatch::ensure-correct-number-of-parts (+ 2 2 4))  ;; early debug
      (let ((peg-in-pin (e/part::get-input-pin net :peg-source-file-name))
            (pseudo-in-pin (e/part::get-input-pin net :pseudo-source-file-name))
            (grammar-name-pin (e/part::get-input-pin net :grammar-name))
            (debug-pin (e/part::get-input-pin net :debug-grammar)))
        (cl-event-passing-user::@send net grammar-name-pin grammar-name)
        (cl-event-passing-user::@send net debug-pin debug)
        (cl-event-passing-user::@send net peg-in-pin peg-filename)
        (cl-event-passing-user::@send net pseudo-in-pin pseudo-filename)))))
  


(defmethod pseudo-parser-reactor ((self e/part:code) (e e/event:event))
  (let ((pin (e/event::event-pin e)))
    (e/part::ensure-valid-input-pin self pin) ;; debug - ensure that event contains a valid pin id
    (ecase (e/event::sym e)
      (:lisp-parser-source
       (cl-peg:into-package :arrowgrams/build/cl-build)  ; Q: why is this needed?
       (eval (e/event::data e))
       (setf arrowgrams/build/cl-build/globals::*peg-parser* t)
       (try-to-parse self))
      
      (:source-to-be-parsed
       (setf arrowgrams/build/cl-build/globals::*pseudo-source* (e/event::data e))
       (try-to-parse self))

      (:grammar-name
       (setf arrowgrams/build/cl-build/globals::*grammar-name* (e/event::data e)))
      
      (:debug-grammar
       (setf arrowgrams/build/cl-build/globals::*debug-grammar* (e/event::data e))))))

(defmethod try-to-parse ((self e/part:code))
  ;; parses IFF both inputs have arrived, otherwise does nothing (a standard pattern for state machines)
  (when (and
         arrowgrams/build/cl-build/globals::*peg-parser*
         arrowgrams/build/cl-build/globals::*pseudo-source*)

    (when (and
           arrowgrams/build/cl-build/globals::*debug-grammar*
           (listp arrowgrams/build/cl-build/globals::*debug-grammar*))
      (mapc #'(lambda (rule)
                (esrap:trace-rule rule))
            arrowgrams/build/cl-build/globals::*debug-grammar*))

    (let ((resulting-lisp (esrap:parse arrowgrams/build/cl-build/globals::*grammar-name*
                                       arrowgrams/build/cl-build/globals::*pseudo-source*)))
      ;; peg parser is esrap-lisp that parses pseudo-code and creates lisp code that mimics the pseudo-code
      ;; send resulting lisp code to output pin
      (cl-event-passing-user::@send self :lisp-source-out resulting-lisp))))
