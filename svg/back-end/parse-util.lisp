(in-package :arrowgrams/compiler/back-end)

;; class needed by SL, must be called "parser"
(defclass parser ()
  ((accepted-token :initform nil :accessor accepted-token)
   (owner :initform nil :accessor owner :initarg :owner)
   (token-stream :initform nil :accessor token-stream :initarg :token-stream)
   (unparsed-token-stream :initform nil :accessor unparsed-token-stream :initarg :token-stream)
   (indent :initform 0 :accessor indent)
   (output-stream :initform (make-string-output-stream) :accessor output-stream)
   (error-stream :initform *error-output* :accessor error-stream)
   (schematic-stack :accessor schematic-stack :initform (make-instance 'stack))
   (queue-stack :accessor queue-stack :initform (make-instance 'stack))
   (table-stack :accessor table-stack :initform (make-instance 'stack))
   (wire-stack :accessor wire-stack :initform (make-instance 'stack))
   (part-stack :accessor part-stack :initform (make-instance 'stack))
   (top-schematic :accessor top-schematic)
   (parts :initform (make-hash-table :test 'equal) :accessor parts)
   (wires :initform (make-hash-table) :accessor wires)
   (unparse-stack :accessor unparse-stack :initform (make-instance 'stack))))


(defun string-token (tok)
  (cond ((eq :lpar (token-kind tok)) "(")
        ((eq :rpar (token-kind tok)) ")")
        ((eq :string (token-kind tok)) (format nil "~A" (token-text tok)))
        ((eq :ws (token-kind tok)) " ")
        ((eq :integer (token-kind tok)) (format nil "integer ~a" (token-text tok)))
        ((eq :symbol (token-kind tok)) (format nil "symbol ~A" (token-text tok)))
        (t (assert nil))))

(defun debug-token (tok)
  (format *standard-output* "~a~%" (string-token tok)))

(defmethod accept ((self parser))
  (setf (accepted-token self) (pop (token-stream self)))
  #+nil(debug-token (accepted-token self)))

(defmethod parser-error ((self parser) kind)
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
    (parser-error self kind)))

(defmethod accept-if ((self parser) kind)
  (when (look-ahead-p self kind)
    (accept self)))

(defmethod get-accepted-token-text ((self parser))
  (token-text (accepted-token self)))

(defmethod accepted-symbol-must-be-nil ((self parser))
  (if (and (eq :symbol (token-kind (accepted-token self)))
           (string= "NIL" (string-upcase (token-text (accepted-token self)))))
      T
    (parser-error self nil)))

(defmethod emit ((self parser) fmtstr &rest args)
  (apply #'format (output-stream self) fmtstr args))

(defmethod get-output ((self parser))
  (get-output-stream-string (output-stream self)))

(defmethod inc ((self parser))
  (incf (indent self) 2))

(defmethod dec ((self parser))
  (decf (indent self) 2))

(defmethod nl ((self parser))
  (let ((count (indent self)))
    (@:loop
      (@:exit-when (<= 0 count))
      (emit self " ")
      (decf count))
    (emit self "~%")))
      


;; parser support
(defmethod must-see ((p parser) token)   (arrowgrams/compiler/back-end:need p token))
(defmethod look-ahead ((p parser) token)   (arrowgrams/compiler/back-end:look-ahead-p p token))
(defmethod output ((p parser) str)   (arrowgrams/compiler/back-end:emit p str))
(defmethod need-nil-symbol ((p parser) str)   (arrowgrams/compiler/back-end:emit p str))
(defmethod call-external ((p parser) func)  (cl:apply func (list p)))
(defmethod call-rule ((p parser) func)  (cl:apply func (list p)))

;; mechanisms used in *collector-rules* and *generic-rules*
(defmethod print-text ((p parser))
  (format (arrowgrams/compiler/back-end:output-stream p)
          "~a"
          (arrowgrams/compiler/back-end:token-text (arrowgrams/compiler/back-end:accepted-token p))))
(defmethod nl ((p parser))
  (format (arrowgrams/compiler/back-end:output-stream p) "~%"))

(defmethod symbol-must-be-nil ((p parser))
  (arrowgrams/compiler/back-end:accepted-symbol-must-be-nil p))

(defmethod stop-here ((p parser))
  (format *standard-output* "p is ~A~%" p)
)

;;;;

(defclass stack ()
  ((stack :initform nil :accessor stack)))

(defmethod stack-push ((self stack) item)
  (cl:push item (stack self)))

(defmethod stack-pop ((self stack))
  (cl:pop (stack self)))

(defmethod stack-top ((self stack))
  (first (stack self)))

(defmethod stack-nth ((self stack) n)
  (nth n (stack self)))

;;;;; unparser support

(defmethod unparse-emit ((p parser) item)
  (setf (unparsed-token-stream p)
        (cons item (unparsed-token-stream p))))
  
(defmethod unparse-emit-token ((p parser) tok)
  (unparse-emit p tok))

(defmethod unparse-push ((p parser) item)
  (stack-push (unparse-stack p) item))

(defmethod unparse-pop ((p parser))
  (stack-pop (unparse-stack p)))

(defmethod unparse-tos ((p parser))
  (stack-top (unparse-stack p)))

(defmethod unparse-call-external ((p parser) func)
  (apply func (list p)))

(defmethod unparse-call-rule ((p parser) func)
  (apply func (list p)))

(defmethod unparse-foreach-in-list ((p parser) func)
  (dolist (L (unparse-tos p))
    (unparse-push p L)
    (apply func (list p))
    (unparse-pop p)))

(defmethod unparse-foreach-in-table ((p parser) func)
  (maphash #'(lambda (key val)
               (declare (ignore key))
               (unparse-push val)
               (apply func (list p))
               (unparse-pop))
           (unparse-tos p)))

(defmethod unparse-dupn ((p parser) n)
  (assert (> n 0))
  (let ((item (stack-nth (unparse-stack p) (1- n)))) ;; 1==top
    (unparse-push p item)))

;;;;;;;; mechanisms for schem-unparse.lisp ;;;;;;;
(defmethod send-top ((p parser))
  (let ((str (unparse-tos p)))
    (assert (stringp str))
    (unparse-emit p str)))