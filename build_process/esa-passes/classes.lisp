(defclass parser (pasm:parser)
  ((method-stream :accessor method-stream :initarg :output-stream :initform (make-string-output-stream))
   (current-class :accessor current-class)
   (current-method :accessor current-method)

   ;; v2 emitter
   (env :accessor env :initform (make-instance 'cl-user::environment))
   (saved-text :accessor saved-text)
   ))

