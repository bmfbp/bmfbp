(in-package :arrowgrams/build)

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
    (if kind
        (format *error-output* "~&parser error in ~s - wanted ~s ~s, but got ~s ~s at line ~a position ~a~%" (current-rule p)
                kind text (token-kind nt) (token-text nt) (token-line nt) (token-position nt))
      (format *error-output* "~&parser error in ~s - got ~s ~s at line ~a position ~a~%" (current-rule p)
              (token-kind nt) (token-text nt) (token-line nt) (token-position nt)))
    (error "parser error")
    (read-next-token p)
    :fail))

(defmethod initialize ((p parser))
  (setf (next-token p) (pop (token-stream p))))


(defmethod accept ((p parser))
  (setf (accepted-token p) (next-token p))
  #+nil(format *standard-output* "~&~s" (token-text (accepted-token p)))
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
    (funcall func p)
    (decf (depth p))
    #+nil (spaces (depth p))
    #+nil (format *standard-output* ">> external ~s~%" func)
    (setf (current-rule p) prev)))

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
    (declare (ignore i))
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
  (token-text (accepted-token p)))

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


(defmethod expr-stack-open ((p parser))
  (setf (expr-stack p) nil)
  (setf (need-close-paren-p p) nil)
  (setf (call-rule-flag p) nil))

(defmethod set-call-rule-flag ((p parser))
  (setf (call-rule-flag p) T))

(defmethod push-symbol-onto-expr-stack ((p parser))
  (push (atext p) (expr-stack p)))

(defmethod emit-expr-stack ((p parser))
  (let ((single-item-p (= 1 (length (expr-stack p))))
        (first-time-p t))
    (unless single-item-p
      (emit p "(")
      (setf (need-close-paren-p p) T))
    (dolist (e (expr-stack p))
      (if first-time-p
          (emit p "~a" e)
        (emit p " ~a" e))
      (setf first-time-p nil))
    (setf (call-rule-flag p) nil)))

(defmethod emit-expr-stack-using-call-rule ((p parser))
  (let ((single-item-p (= 1 (length (expr-stack p)))))
    (unless single-item-p
      (emit p "(")
      (setf (need-close-paren-p p) T))
    (when (call-rule-flag p)
      (emit p "call-rule"))
    (dolist (e (expr-stack p))
      (if (call-rule-flag p)
          (emit p " #'~a" e)
        (emit p " ~a" e))
      (setf (call-rule-flag p) nil))))

(defmethod emit-expr-actual ((p parser))
  (emit p " ~a" (atext p)))

(defmethod expr-stack-close ((p parser))
  (when (need-close-paren-p p)
    (emit p ") ")))

(defmethod push-symbol ((p parser))
  (push (atext p) (symbol-stack p)))

(defmethod pop-symbol ((p parser))
  (pop (symbol-stack p)))
