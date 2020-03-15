(in-package :arrowgrams/compiler)

(defclass synchronizer (compiler-part)
  ((json-filename :accessor json-filename)
   (generic-filename :accessor generic-filename)
   (lisp-filename :accessor lisp-filename)
   (ir :accessor ir)))

(defmethod e/part:busy-p ((self synchronizer)) (call-next-method))
; (:code synchronizer (:ir :json-filename :generic-filename :lisp-filename)
;                     (:ir :json-filename :generic-filename :lisp-filename :error)
;                     #'BE:e/part:react #'BE:e/part:first-time)

(defmethod e/part:first-time ((self synchronizer))
  (setf (json-filename self) nil
        (generic-filename self) nil
        (lisp-filename self) nil)
  (setf (ir self) nil)
  (call-next-method))

(defmethod e/part:react ((self synchronizer) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (flet ((run-if-ready () ;; example of dataflow where all inputs must be satisfied before proceeding
             (when (and (ir self) (json-filename self) (generic-filename self) (lisp-filename self))
               (setf (state self) :running)
               (@send self :json-filename (json-filename self))
               (@send self :generic-filename (generic-filename self))
               (@send self :lisp-filename (lisp-filename self))
               (@send self :ir (ir self))
               (e/part:first-time self))))
(format *standard-output* "~&back-end synchrnonizer gets ~s ~s~%" (@pin self e) (@data self e))      
      (ecase (state self)
        (:idle
         (ecase pin
           (:ir (setf (ir self) (e/event:data e))
            (run-if-ready))
           (:json-filename (setf (json-filename self) (e/event:data e))
            (run-if-ready))
           (:generic-filename (setf (generic-filename self) (e/event:data e))
            (run-if-ready))
           (:lisp-filename (setf (lisp-filename self) (e/event:data e))
            (run-if-ready))))
         
         (:done
          (let ((msg (format nil "synchronizer in state :done expected <nothing>, but got action ~S data ~S" pin (e/event:data e))))
            (@send self :error msg)
            (format *standard-output* "~&~s~%" msg)))))))