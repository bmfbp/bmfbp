(in-package :arrowgrams/compiler/back-end)

(defparameter *token-stream* nil) ;; an ordered list of tokens
(defparameter *parser-output-stream* nil)

(defun string-token (tok)
  (cond ((eq :lpar (token-kind tok)) "(")
        ((eq :rpar (token-kind tok)) ")")
        ((eq :string (token-kind tok)) (format nil "string ~A" (token-text tok)))
        ((eq :ws (token-kind tok)) " ")
        ((eq :integer (token-kind tok)) (format nil "integer ~a" (token-text tok)))
        ((eq :symbol (token-kind tok)) (format nil "symbol ~A" (token-text tok)))
        (t (assert nil))))

(defun debug-token (tok)
  (format *standard-output* "~a~%" (string-token tok)))

(defun accept (self)
  (declare (ignore self))
  (let ((val (first *token-stream*)))
    (setf *token-stream* (cdr *token-stream*))
    ;(debug-token val)
    val))

(defun parse-error (self kind)
  (let ((strm *token-stream*))
    (let ((msg (format nil "~&parser error expecting ~S, but got ~S ~%~%" kind (first *token-stream*))))
      (assert nil () msg)
      (send! self :error msg)
      (setf *token-stream* (cdr strm)) ;; stream is volatile to help debugging
      nil)))

(defun skip-ws (self)
  (declare (ignore self))
  (@:loop
    (@:exit-when (not (eq :ws (token-kind (first *token-stream*)))))
    (pop *token-stream*)))

(defun look-ahead-p (self kind)
  (skip-ws self)
  (and *token-stream*
       (eq kind (token-kind (first *token-stream*)))))

(defun need (self kind)
  (if (look-ahead-p self kind)
      (accept self)
    (parse-error self kind)))

(defun accept-if (self kind)
  (when (look-ahead-p self kind)
    (accept self)))

(defun need-nil-symbol (self)
  (if (and (look-ahead-p self :symbol)
           (string= "NIL" (string-upcase (token-text (first *token-stream*)))))
      (accept self)
    (parse-error self nil)))

(defun emit (fmtstr &rest args)
  (apply #'format *parser-output-stream* fmtstr args))

