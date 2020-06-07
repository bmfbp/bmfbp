(in-package :arrowgrams/esa-transpiler)

(defclass string-stack-entry () 
  ((counter :accessor counter :initform 0)
   (str-stack :accessor str-stack :initform nil)))
  
(defmethod print-object ((obj string-stack-entry) out)
  (format out "[~a ~S]" (counter obj) (str-stack obj)))


(defclass class-descriptor ()
  ((methods :accessor methods :initform (make-hash-table :test 'equal))
   (name :accessor name :initarg nil)))

(defun make-empty-class ()
  (make-instance 'class-descriptor))


(defclass method-descriptor ()
  ((name :accessor name)
   (map? :accessor map? :initform nil)  ;; t or nil (true or false)
   (code-stream :accessor code-stream :initform (make-string-output-stream)) ;; later ... (get-output-stream-string ...) on this field
   (parameters :accessor parameters :initform nil) ;; must be a sequential, indexable list
   (formals-index :accessor formals-index :initform 0) ;; 1+ number of formals
   (return-parameters :accessor return-parameters :initform (make-hash-table :test 'equal))
   ))

(defclass parameter-descriptor ()
  ((name :accessor name :initform :unknown)
   (parameter-type :accessor parameter-type :initform :unknown)
   (map? :accessor map? :initform nil)))


(defclass parser (pasm:parser)
  ((method-stream :accessor method-stream :initarg :output-stream :initform (make-string-output-stream))
   (current-class :accessor current-class)
   (current-method :accessor current-method)

   (esaprogram :accessor esaprogram) ;; passing main data structure between passes
   
   ;; v2 emitter
   (env :accessor env :initform (make-instance 'cl-user::environment))
   (saved-text :accessor saved-text)
   ))

