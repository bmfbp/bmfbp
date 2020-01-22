(in-package :arrowgrams/compiler/back-end)

(defclass parser ()
  ((owner :initform nil :accessor owner :initarg :owner)
   (token-stream :initform nil :accessor token-stream :initarg :token-stream)
   (indent :initform 0 :accessor indent)
   (output-stream :initform (make-string-output-stream) :accessor output-stream)))

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

(defmethod accept ((self parser))
  (pop (token-stream self)))
    ;(debug-token val)

(defmethod parse-error ((self parser) kind)
  (let ((msg (format nil "~&parser error expecting ~S, but got ~S ~%~%" kind (first (token-stream self)))))
      (assert nil () msg)
      (send! (owner self) :error msg)
      (pop (token-stream self)) ;; stream is volatile to help debugging
      nil))

(defmethod skip-ws ((self parser))
  (@:loop
    (@:exit-when (not (eq :ws (token-kind (first (token-stream self))))))
    (pop (token-stream self))))

(defmethod look-ahead-p ((self parser) kind)
  (skip-ws self)
  (and (token-stream self)
       (eq kind (token-kind (first (token-stream self))))))

(defmethod need ((self parser) kind)
  (if (look-ahead-p self kind)
      (accept self)
    (parse-error self kind)))

(defmethod accept-if ((self parser) kind)
  (when (look-ahead-p self kind)
    (accept self)))

(defmethod need-nil-symbol ((self parser))
  (if (and (look-ahead-p self :symbol)
           (string= "NIL" (string-upcase (token-text (first (token-stream self))))))
      (accept self)
    (parse-error self nil)))

(defmethod emit ((self parser) fmtstr &rest args)
  (apply #'format (output-stream self) fmtstr args))

(defmethod get-output ((self parser))
  (get-output-stream-string (output-stream self)))

(defmethod inc ((self parser))
  (incf (indent self) 2))

(defmethod inc ((self parser))
  (decf (indent self) 2))

