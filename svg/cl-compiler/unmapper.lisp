;; this Component reads in the temp-string-map.lisp file created by the Arrowgrams compiler
;; it then filters (in state :unmapping) every incoming fact and replaces symbols like struidG0 with their (lisp) string equivalents
;;
;; this filter should be place in front of the :lisp-fact pin of Component fb

;; History: when the 2nd version of the compiler was built, it used gprolog.  Gprolog did not work in the presence of string atoms (e.g. containing spaces), so the lisp front-end replaced all lisp strings with symbols of the form struidG0 and created a mapping file from symbol to strings.  This mapping file was used after all of the gprolog passes (and before the emitter) to covert symbols back into full strings.

;; History: this was a temporary measure.

;; History: the 3rd version of the compiler uses Lisp and Nils Holm's Prolog (ported from Scheme to Common Lisp).  There is no need for removing strings in this 3rd version.  During bootstrapping, we are using version 2 factbases and temp-string-maps and we need to map strings back into the (version 2) factbase.

;; History/Present: when we are done testing, we won't be creating and using temp-string-map.lisp.  In this case,
;; will will just send NIL to the :map-filename pin of this component and it will do nothing.  It will not read
;; the temp-string-map.lisp file and will pass incoming facts on to :out, unadulterated.

; (:code unmapper (:map-filename :in :done) (:out :done :error))

(in-package :arrowgrams/compiler)

(defclass unmapper (e/part:part)
  ((state :initform :waiting-for-map :accessor state)
   (mapping :accessor mapping)
   (mapping-p :accessor mapping-p))) ;; T if we are doing unmapping, else NIL


; (:code unmapper (:file-name) (:string-fact :eof :error))

(defmethod e/part:busy-p ((self unmapper))
  (call-next-method))

(defmethod e/part:first-time ((self unmapper)))
  
(defmethod e/part:react ((self unmapper) (e e/event:event))
  (ecase (state self)
    (:waiting-for-map
     (ecase (@pin self e)
       (:map-filename
	(if (null :map-filename)
	    (setf (mapping-p self) nil)
	    (with-open-file (f (@data self e) :direction :input)
	      (setf (mapping-p self) T)
	      (let ((sexpr (read f nil :eof))
		    (mapping (make-hash-table)))
		(@:loop
		  (@:exit-when (eq :eof sexpr))
		  (assert (listp sexpr))
		  (let ((sym (intern (symbol-name (first sexpr)) "KEYWORD"))
			(str (second sexpr)))
		    (assert (symbolp sym))
		    (assert (stringp str))
		    (multiple-value-bind (val success)
			(gethash sym mapping)
		      (declare (ignore val))
		      (assert (not success))
		      (setf (gethash sym mapping) str)))
		  (setf sexpr (read f nil :eof)))
		(setf (mapping self) mapping))))
	(setf (state self) :unmapping))))

    (:unmapping
     (ecase (@pin self e)
       (:in
        (let ((fact (@data self e)))
          (if (mapping-p self)
	      (ecase (length fact)
		(2
		 (let ((f1 (first fact))
		       (f2 (second fact)))
		   (multiple-value-bind (v1 success1) (gethash f1 (mapping self))
		     (multiple-value-bind (v2 success2) (gethash f2 (mapping self))
		       (let ((new-fact (list (if success1 v1 f1) (if success2 v2 f2))))
			 (@send self :out new-fact))))))
		(3
		 (let ((f1 (first fact))
		       (f2 (second fact))
		       (f3 (third fact)))
		   (multiple-value-bind (v1 success1) (gethash f1 (mapping self))
		     (multiple-value-bind (v2 success2) (gethash f2 (mapping self))
		       (multiple-value-bind (v3 success3) (gethash f3 (mapping self))
			 (let ((new-fact (list (if success1 v1 f1) (if success2 v2 f2) (if success3 v3 f3))))
			   (@send self :out new-fact))))))))
            (@send self :out fact))))
       
       (:done
        (@send self :done t))))))
