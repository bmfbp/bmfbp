(in-package :arrowgrams/esa)

(defmethod read-next-token ((p parser) &optional (debug t))
  (unless (eq :eof (token-kind (accepted-token p)))
    (setf (next-token p) (pop (token-stream p)))
    (when debug
      (cond ((eq :eof (token-kind (accepted-token p)))
             #+nil(format *standard-output* "		next-token: no more tokens~%"))
            (t #+nil(format *standard-output* "		next-token ~s ~s ~a ~a~%" (token-kind (next-token p)) (token-text (next-token p))
                       (token-line (next-token p)) (token-position (next-token p))))))))

(defmethod parser-err ((p parser) kind text)
  (let ((nt (next-token p)))
    (let ((error-message
	   (if kind
               (format nil "~&parser error in ~s - wanted ~s ~s, but got ~s ~s at line ~a position ~a~%" (current-rule p)
                       kind text (token-kind nt) (token-text nt) (token-line nt) (token-position nt))
	       (format nil "~&parser error in ~s - got ~s ~s at line ~a position ~a~%" (current-rule p)
		       (token-kind nt) (token-text nt) (token-line nt) (token-position nt)))))
    (error "parser error ~s" error-message)
    (read-next-token p)
    :fail)))

(defmethod semantic-error ((p parser) fmtstr &rest fmtargs)
  (let ((msg (apply 'format *error-output* fmtstr fmtargs)))
    (error msg))) ;; parser should try to continue - error only during bootstrap

(defmethod initialize ((p parser))
  (setf (next-token p) (pop (token-stream p))))


(defmethod accept ((p parser))
  (setf (accepted-token p) (next-token p))
  (format *standard-output* "~&~s" (token-text (accepted-token p)))
  (read-next-token p)
  :ok)

(defmethod input ((p parser) kind)
  (if (eq kind (token-kind (next-token p)))
      (accept p)
    (parser-err p kind "")))

(defmethod input-symbol ((p parser) text)
  (if (and (eq :symbol (token-kind (next-token p)))
           (string= text (token-text (next-token p))))
      (accept p)
    (parser-err p :symbol text)))

(defmethod input-upcase-symbol ((p parser))
  (if (and (eq :symbol (token-kind (next-token p)))
           (all-upcase-p (token-text (next-token p))))
        (accept p)
    (parser-err p 'upcase-symbol (token-text (next-token p)))))

(defmethod input-char ((p parser) char)
  (if (and (eq :character (token-kind (next-token p)))
           (char= (token-text (next-token p)) char))
      (accept p)
    (parser-err p :character char)))

(defmethod look-upcase-symbol? ((p parser))
  (if (and (eq :symbol (token-kind (next-token p)))
           (all-upcase-p (token-text (next-token p))))
      :ok
    :fail))

(defmethod look-char? ((p parser) c)
  (if (and (eq :character (token-kind (next-token p)))
           (char= (token-text (next-token p)) c))
      :ok
    :fail))

(defmethod look? ((p parser) kind)
  (if (eq kind (token-kind (next-token p)))
      :ok
    :fail))

(defmethod look-symbol? ((p parser) text)
  (if (and (eq :symbol (token-kind (next-token p)))
           (string= text (token-text (next-token p))))
      :ok
    :fail))

(defun all-upcase-p (s)
  (dotimes (i (length s))
    (unless (upper-case-p (char s i))
      (return-from all-upcase-p nil)))
  t)


;;  code emission mechanisms

(defmethod emit ((p parser) fmtstr &rest args)
  (let ((str (apply #'format nil fmtstr args)))
    (write-string str (output-stream p))))

(defmethod emit-raw ((p parser) str)
  (dotimes (i (length str))
    (write-char (char str i) (output-stream p))))

(defmethod emit-true ((p parser))
  (write-string " :true" (output-stream p)))

(defmethod emit-false ((p parser))
  (write-string " :false" (output-stream p)))


(defmethod emit-to-method-stream ((p parser) fmtstr &rest args)
  (let ((str (apply #'format nil fmtstr args)))
    (write-string str (method-stream p))))

(defmethod emit-methods ((p parser))
  (write-string (get-output-stream-string (method-stream p)) (output-stream p))
  (write-string "

" (output-stream p)))


;;; support for generated parser

(defmethod call-external ((p parser) func)
  (let ((prev (current-rule p)))
    (setf (current-rule p) func)
    #+nil (spaces (depth p))
    (incf (depth p))
    #+nil (format *standard-output* "call-external ~s~%" func)
    (let ((r (funcall func p)))
      (decf (depth p))
      #+nil (spaces (depth p))
      #+nil (format *standard-output* ">> external ~s~%" func)
      (setf (current-rule p) prev)
      r)))

(defmethod call-rule ((p parser) func)
  (let ((prev (current-rule p)))
    (setf (current-rule p) func)
    #+nil (spaces (depth p))
    (incf (depth p))
    #+nil (format *standard-output* "call-rule ~s~%" func)
    (funcall func p)
    (decf (depth p))
    #+nil (spaces (depth p))
    #+nil (format *standard-output* ">> rule ~s~%" func)
    (setf (current-rule p) prev)))
  
(defmethod call-predicate ((p parser) func)
  (let ((prev (current-rule p)))
    (setf (current-rule p) func)
    #+nil (spaces (depth p))
    (incf (depth p))
    #+nil (format *standard-output* "call-predicate ~s~%" func)
    (let ((r (funcall func p)))
      (decf (depth p))
      #+nil (spaces (depth p))
      #+nil (format *standard-output* ">> ~s predicate ~s~%" r func)
      (setf (current-rule p) prev)
      r)))
      

(defun spaces (n)
  (format *standard-output* "~&")
  (dotimes (i n)
    (format *standard-output* " ")))

;; esa mechanisms

(defmethod clear-saved-text ((p parser))
  (setf (saved-text p) ""))

(defmethod save-text ((p parser))
  (setf (saved-text p) (token-text (accepted-token p))))

(defmethod combine-text ((p parser))
  (let ((text (token-text (accepted-token p))))
    (let ((combined-text (strip-quotes (concatenate 'string (saved-text p) (string text)))))
      (setf (token-text (accepted-token p)) combined-text)
      (setf (saved-text p) combined-text))))

(defmethod atext ((p parser))
  (concatenate 'string "" (string (token-text (accepted-token p)))))

(defmethod clear-method-stream ((p parser))
  (setf (method-stream p) (make-string-output-stream)))

(defmethod set-current-class ((p parser))
  (setf (current-class p) (atext p)))

(defmethod set-current-method ((p parser))
  (setf (current-method p) (atext p)))

(defun strip-quotes (s)
  (if (and (char= #\" (char s 0))
           (char= #\" (char s (1- (length s)))))
      (subseq s 1 (1- (length s)))
    s))


(defmethod string-stack-open ((p parser))
  (let ((entry (make-instance 'string-stack-entry)))
    (setf (counter entry) 0)
    (setf (str-stack entry) nil)
    (push entry (string-stack p))))


(defmethod top-of-string-stack ((p parser))
  (first (string-stack p)))

(defmethod push-string ((p parser))
  (push (atext p) (str-stack (top-of-string-stack p))))

(defmethod string-stack-empty ((p parser))
  (null (str-stack (top-of-string-stack p))))

(defmethod string-stack-has-only-one-item ((p parser))
  (let ((len (length (str-stack (top-of-string-stack p)))))
    (assert (>= len 0))
    (= len 1)))

(defmethod emit-string-pop ((p parser))
  (let ((str (pop (str-stack (top-of-string-stack p)))))
    (emit p " ~a" str)))

(defmethod emit-lpar-inc-count ((p parser))
  (emit p "(")
  (incf (counter (top-of-string-stack p))))

(defmethod set-lpar-count-to-1 ((p parser))
  (setf (counter (top-of-string-stack p)) 1))

(defmethod emit-rpars-count-less-1 ((p parser))
  (assert (>= (counter (top-of-string-stack p)) 0))
  (@:loop
    (@:exit-when (<= (counter (top-of-string-stack p)) 1))
    (decf (counter (top-of-string-stack p)))
    (emit p ")")))

(defmethod emit-rpars ((p parser))
  (assert (or (= 0 (counter (top-of-string-stack p)))
              (= 1 (counter (top-of-string-stack p)))))
  (when (= 1 (counter (top-of-string-stack p)))
    (emit p ")")))

(defmethod string-stack-close ((p parser))
  (pop (string-stack p)))



;;;;;;;  v2 emitter additions ;;;;;;;;;
;;; mechanisms (callable from esa_js.rp)

(defmethod reset-classes ((p parser))
  (format *standard-output* "~&*** reset classes 1 p=~s" p)
  (setf (class-descriptor-stack p) nil)
  (format *standard-output* "~&*** reset classes 3 p=~s c=~s~%" p (esa-classes p))
  (setf (method-descriptor-stack p) nil)
  (format *standard-output* "~&*** reset classes 4 p=~s c=~s~%" p (esa-classes p))
  (setf (esa-classes p) (make-hash-table :test 'equal))
  (format *standard-output* "~&*** reset classes 2 p=~s c=~s~%" p (esa-classes p))
  (format *standard-output* "~&*** reset classes 2a p=~s classes=~s~%" p (esa-classes p))
  (format *standard-output* "~&*** in reset-classes (esa-classes p=~s) type-of=~s val=~s~%" 
	  (esa-classes p)
	  (type-of (esa-classes p)) 
	  (esa-classes p))
  (format *standard-output* "~&*** reset classes 2b p=~s~%" p)
)

(defmethod open-new-class-descriptor ((p parser))
  (let ((esa-class-name (atext p)))
    (multiple-value-bind (val success)
	(gethash esa-class-name (esa-classes p))
      (declare (ignore val))
      (when success
	(semantic-error "class ~a is being declared more than once" esa-class-name)))
    (format *standard-output* "~&ocd: (esa-classes p=~s) type-of=~s val=~s~%" p (type-of (esa-classes p)) (esa-classes p))
    (let ((c (make-empty-class)))
      (setf (gethash esa-class-name (esa-classes p)) c)
      (setf (name c) esa-class-name)
      (push c (class-descriptor-stack p)))))

(defmethod close-new-class-descriptor ((p parser))
  (pop (class-descriptor-stack p)))

(defmethod open-existing-class-descriptor ((p parser))
  (let ((esa-class-name (atext p)))
    (multiple-value-bind (class-descriptor success)
	(gethash esa-class-name (esa-classes p))
      (declare (ignore val))
      (unless success
	(semantic-error "class ~a has not been declared (but is being defined)" esa-class-name))
      (push class-descriptor (class-descriptor-stack p)))))

(defmethod close-existing-class-descriptor ((p parser))
  (pop (class-descriptor-stack p)))

(defmethod close-all-classes ((p parser))
  (@:loop
    (@:exit-when (null (class-descriptor-stack p)))
    (pop (class-descriptor-stack p))))

(defmethod top-class ((p parser))
  (first (class-descriptor-stack p)))

(defun make-empty-method-descriptor ()
  (make-instance 'method-descriptor))

(defun make-parameter-descriptor ()
  (make-instance 'parameter-descriptor))



;; method mechanisms

(defmethod open-new-method-descriptor ((p parser))
  (let ((desc (make-empty-method-descriptor)))
    (let ((method-name (atext p)))
      (setf (name desc) method-name)
      (multiple-value-bind (val success)
	  (gethash method-name (methods (top-class p)))
	(declare (ignore val))
	(when success
	  (semantic-error p (format nil "method ~s already declared for class ~s" 
				    method-name (top-class p))))
	(setf (gethash method-name (methods (top-class p)))
	      desc)
	(push desc (method-descriptor-stack p))))))

(defmethod close-new-method-descriptor ((p parser))
  (pop (method-stack p)))


(defmethod open-existing-method-descriptor ((p parser))
    (let ((method-name (atext p)))
      (multiple-value-bind (method-desc success)
	  (gethash method-name (methods (top-class p)))
	(declare (ignore val))
	(unless success
	  (semantic-error p (format nil "method ~s has not been declared for class ~s (but is being defined in a WHEN)" 
				    method-name (top-class p))))
	(push desc (method-descriptor-stack p)))))

(defmethod close-existing-method-descriptor ((p parser))
  (pop (method-stack p)))
  

(defmethod top-method ((p parser))
  (first (method-descriptor-stack p)))

(defmethod set-current-method-as-map ((p parser))
  (setf (map? (top-method p)) t))

(defmethod ensure-parameter-not-declared ((p parser) name)
  (let ((method-desc (top-method p)))
    (multiple-value-bind (val success)
	(gethash name (parameters method-desc))
      (declare (ignore val))
      (when success
	(error "attempt to declare parameter ~s more than once in method ~s"
	       name method-desc)))))

(defmethod put-parameter ((p parser) name (desc parameter-descriptor))
  (setf (gethash name (parameters (top-method p)))
	desc))

(defmethod add-formal-parameter-to-method ((p parser))
  (let ((param-name (atext p)))
    (ensure-parameter-not-declared p param-name)
    (let ((param-descriptor (make-parameter-descriptor)))
      (setf (name pdesc) param-name)
      (put-parameter p param-name param-descriptor))))

(defmethod add-return-type ((self method-descriptor) (r parameter-descriptor))
  (setf (gethash (name r) (return-parameters self)) r))

(defmethod push-new-return-type ((p parser))
  (let ((return-type-name (atext p)))
    (let ((method-desc (top-method p)))
      (let ((param-descriptor (make-parameter-descriptor)))
	(setf (name param-descriptor return-type-name))
	(push param-descriptor (parameter-descriptor-stack p))
	(add-return-type method-desc param-descriptor)))))
  
(defmethod has-return-type? ((p parser) m)
  (declare (ignore p))
  (> (hash-table-count (return-parameters m)) 0))

(defmethod set-return-type-as-map ((p parser))
  (let ((m (top-method p)))
    (assert (has-return-type? p m)) ;; internal bug if no return type at this point
    (setf (map? (top-parameter p)) t)))

(defmethod top-parameter ((p parser))
  (first (parameter-descriptor-stack p)))



;; emitter to method body stream
(defmethod emit-code ((p parser) str)
  (format (code-stream (top-method p)) str))

(defmethod emit-code-true ((p parser))
  (emit-code p ":true"))

(defmethod emit-code-false ((p parser))
  (emit-code p ":false"))

(defmethod emit-code-symbol ((p parser))
  (emit-code p (format nil "~a" (atext p))))

(defmethod emit-code-dot ((p parser))
  (emit-code p "."))

(defmethod emit-code-slash ((p parser))
  (emit-code p "-slash-"))

(defmethod emit-code-question ((p parser))
  (emit-code p "-question"))

(defmethod emit-code-dash ((p parser))
  (emit-code p "-dash-"))

(defmethod emit-code-primed ((p parser))
  (emit-code p "-primed"))

(defmethod emit-code-comma ((p parser))
  (emit-code p ","))

(defmethod emit-code-lpar ((p parser))
  (emit-code p "("))

(defmethod emit-code-rpar ((p parser))
  (emit-code p ")"))

