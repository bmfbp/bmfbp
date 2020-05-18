(in-package :arrowgrams/esa-transpiler)

(defun all-upcase-p (s)
  (dotimes (i (length s))
    (unless (upper-case-p (char s i))
      (return-from all-upcase-p nil)))
  t)

(defmethod read-next-token ((p parser) &optional (debug t))
  (unless (eq :eof (scanner:token-kind (pasm:accepted-token p)))
    (setf (next-token p) (pop (token-stream p)))
    (when debug
      (cond ((eq :eof (scanner:token-kind (pasm:accepted-token p)))
             #+nil(format *standard-output* "		next-token: no more tokens~%"))
            (t #+nil(format *standard-output* "		next-token ~s ~s ~a ~a~%" (scanner:token-kind (next-token p)) (token-text (next-token p))
                       (token-line (next-token p)) (token-position (next-token p))))))))

(defmethod parser-err ((p parser) kind text)
  (let ((nt (next-token p)))
    (let ((error-message
	   (if kind
               (format nil "~&parser error in ~s - wanted ~s ~s, but got ~s ~s at line ~a position ~a~%" (current-rule p)
                       kind text (scanner:token-kind nt) (scanner:token-text nt) (scanner:token-line nt) (scanner:token-position nt))
	       (format nil "~&parser error in ~s - got ~s ~s at line ~a position ~a~%" (current-rule p)
		       (scanner:token-kind nt) (scanner:token-text nt) (scanner:token-line nt) (scanner::token-position nt)))))
    (error "parser error ~s" error-message)
    ;(read-next-token p)
    :fail)))

(defmethod semantic-error ((p parser) fmtstr &rest fmtargs)
  (let ((msg (apply 'format nil fmtstr fmtargs)))
    (error msg))) ;; parser should try to continue - error only during bootstrap

(defmethod initialize ((p parser))
  (setf (next-token p) (pop (token-stream p))))


(defmethod accept ((p parser))
  (setf (pasm:accepted-token p) (next-token p))
  (format *standard-output* "~&~s" (scanner:token-text (pasm:accepted-token p)))
  (read-next-token p)
  :ok)

(defmethod input ((p parser) kind)
  (if (eq kind (scanner:token-kind (next-token p)))
      (accept p)
    (parser-err p kind "")))

(defmethod input-symbol ((p parser) text)
  (if (and (eq :symbol (scanner:token-kind (next-token p)))
           (string= text (scanner:token-text (next-token p))))
      (accept p)
    (parser-err p :symbol text)))

(defmethod input-upcase-symbol ((p parser))
  (if (and (eq :symbol (scanner:token-kind (next-token p)))
           (all-upcase-p (scanner:token-text (next-token p))))
        (accept p)
    (parser-err p 'upcase-symbol (scanner:token-text (next-token p)))))

(defmethod input-char ((p parser) char)
  (if (and (eq :character (scanner:token-kind (next-token p)))
           (char= (scanner:token-text (next-token p)) char))
      (accept p)
    (parser-err p :character char)))

(defmethod look-upcase-symbol? ((p parser))
  (if (and (eq :symbol (scanner:token-kind (next-token p)))
           (all-upcase-p (scanner:token-text (next-token p))))
      :ok
    :fail))

(defmethod look-char? ((p parser) c)
  (if (and (eq :character (scanner:token-kind (next-token p)))
           (char= (scanner:token-text (next-token p)) c))
      :ok
    :fail))

(defmethod look? ((p parser) kind)
  (if (eq kind (scanner:token-kind (next-token p)))
      :ok
    :fail))

(defmethod look-symbol? ((p parser) text)
  (if (and (eq :symbol (scanner:token-kind (next-token p)))
           (string= text (scanner:token-text (next-token p))))
      :ok
    :fail))


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

(defmethod push-text ((p parser))
  (setf (saved-text p) (string (scanner:token-text (pasm:accepted-token p)))))

(defmethod pop-text ((p parser))
  (setf (scanner:token-text (pasm:accepted-token p)) (saved-text p)))

(defmethod atext ((p parser))
  (concatenate 'string "" (string (scanner:token-text (pasm:accepted-token p)))))

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

(defmethod emit ((p parser) fmtstr &rest args)
  (let ((str (apply #'format nil fmtstr args)))
    (write-string str (output-stream p))))

(defmethod emit-package ((p parser))
  (emit p "(in-package :arrowgrams/esa)"))


