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

(defmethod open-class-descriptor ((p parser))
  (let ((esa-class-name (atext p)))
(format *standard-output* "~&(esa-classes p=~s) type-of=~s val=~s~%" p (type-of (esa-classes p)) (esa-classes p))
    (unless (or (null (esa-classes p))
		(<= 0 (hash-table-count (esa-classes p))))
      (multiple-value-bind (val success)
	  (gethash esa-class-name (esa-classes p))
	(declare (ignore val))
	(when success
	  (semantic-error "class ~a is being declared more than once" esa-class-name))))
(format *standard-output* "~&ocd: (esa-classes p=~s) type-of=~s val=~s~%" p (type-of (esa-classes p)) (esa-classes p))
    (let ((c (make-empty-class)))
      (setf (gethash esa-class-name (esa-classes p))
	    c)
      (setf (name c) esa-class-name)
      (push c (class-descriptor-stack p)))))

(defmethod close-class-descriptor ((p parser))
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

;;; current-class mechanism

(defmethod current-class-push ((p parser))
  (let ((class-name (atext p)))
    (multiple-value-bind (class-descriptor success)
	(gethash class-name (esa-classes p))
      (assert success) ;; internal bug if class not found
      (push class-descriptor (class-descriptor-stack p)))))

(defmethod current-class-pop ((p parser))
  (assert (class-descriptor-stack p)) ;; internal bug if stack empty
  (pop (class-descriptor-stack p)))


(defmethod open-method-descriptor ((p parser))
  (let ((m (make-empty-method-descriptor)))
    (setf (name m) (atext p))
    (push m (method-descriptor-stack p))))

(defmethod close-method-descriptor ((p parser))
  (pop (method-descriptor-stack p)))

(defmethod top-method ((p parser))
  (first (method-descriptor-stack p)))

(defmethod set-current-method-as-map ((p parser))
  (setf (map? (top-method p)) t))

(defmethod open-method-descriptor-for-current-class ((p parser))
  (open-method-descriptor p)
  (setf (gethash 'methods (top-class p)) (top-method p)))

(defmethod add-formal-parameter-to-method ((p parser))
  (let ((pdesc (make-parameter-descriptor)))
    (setf (name pdesc) (atext p))
    (push pdesc (parameters (top-method p)))))

(defmethod add-return-type-to-current-method ((p parser))
  (let ((pdesc (make-parameter-descriptor)))
    (setf (name pdesc) (atext p))
    (push pdesc (return-parameters (top-method p)))))
  
(defmethod has-return-type? ((p parser) m)
  (declare (ignore p))
  (not (null (return-parameters m))))

(defmethod set-return-type-as-map ((p parser))
  (let ((m (top-method p)))
    (assert (has-return-type? p m)) ;; internal bug if no return type at this point
    (setf (map? (first (return-parameters m))) t)))


(defmethod method-open ((p parser))
  ;; find method with accepted-token name and push it onto the top of the method stack
  (assert (not (null (class-descriptor-stack p)))) ;; internal bug if empty
  (let ((method-name (atext p)))
    (multiple-value-bind (method-descriptor success)
	(gethash method-name (methods (top-class p)))
      (assert success)  ;; internal bug if method not found
      (push method-descriptor (method-descriptor-stack p)))))

(defmethod method-close ((p parser))
  (pop (method-descriptor-stack p)))

(defmethod method-attach-to-class ((p parser))
  ;; no op - should be already attached
  )


;; emitter to method body stream
(defmethod emit-code ((p parser) str)
  (format (code-stream (top-method p)) str))

(defmethod emit-code-true ((p parser))
  (emit-code p "true"))

(defmethod emit-code-false ((p parser))
  (emit-code p "false"))

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

(defmethod create-method-descriptor-for-class ((p parser))
  (let ((mdesc (make-instance 'method-descriptor)))
    (push mdesc (methods (top-class p)))
    (push mdesc (method-descriptor-stack p))))