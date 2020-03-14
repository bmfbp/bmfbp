(in-package :arrowgrams/build)

(defclass string-stack-entry () 
  ((count :accessor count :initform 0)
   (str-stack :accessor str-stack :initform nil)))
  

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
   (string-stack :accessor string-stack)
   ))
