(in-package :arrowgrams/build)

(defclass parser (e/part:code)
  ((token-stream :accessor token-stream :initarg :token-stream :initform nil) ;; actually, just a list
   (output-stream :accessor output-stream :initarg :output-stream :initform (make-string-output-stream))
   (next-token :accessor next-token :initform nil)
   (accepted-token :accessor accepted-token :initform nil)
   (state :accessor state :initform :idle)
   (current-rule :accessor current-rule :initform nil)
   (depth :accessor depth :initform 0)
   (saved-text :accessor saved-text :initform "")
   (method-stream :accessor method-stream :initarg :output-stream :initform (make-string-output-stream))
   (current-class :accessor current-class)
   (current-method :accessor current-method)
   (expr-stack :accessor expr-stack :initform nil)
   (call-rule-flag :accessor call-rule-flag :initform nil)
   (need-closing-rpar-flag-stack :accessor need-closing-rpar-flag-stack :initform nil) ;; flag ugh - maybe we should be constructing a lisp list, then convert it to a string?  package-ing might get in the way
   (symbol-stack :accessor symbol-stack :initform nil)
   ))

(defclass filter (parser) ())
