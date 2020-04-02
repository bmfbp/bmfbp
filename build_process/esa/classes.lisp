(in-package :arrowgrams/build)

(defclass string-stack-entry () 
  ((counter :accessor counter :initform 0)
   (str-stack :accessor str-stack :initform nil)))
  
(defmethod print-object ((obj string-stack-entry) out)
  (format out "[~a ~S]" (counter obj) (str-stack obj)))


(defclass class-descriptor ()
  ((methods :accessor methods :initform (make-hash-table :test 'equal))))

(defun make-empty-class ()
  (make-instance 'class-descriptor))


(defclass method-descriptor ()
  ((name :accessor name)
   (map? :accessor map? :initform nil)  ;; t or nil (true or false)
   (code-stream :accessor code-stream :initform (make-string-output-stream)) ;; later ... (get-output-stream-string ...) on this field
   (parameters :accessor parameters :initform nil)
   (return-parameters :accessor return-parameters :initform nil)
   ))

(defclass parameter-descriptor ()
  ((name :accessor name)
   (map? :accessor map? :initform nil)))


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
   (string-stack :accessor string-stack :initform nil)

   ;; class stuff for v2 emission
   
   ))
