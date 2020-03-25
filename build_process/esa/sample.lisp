(in-package :arrowgrams/build)

(defclass fake-class ()
  ((field-a :accessor field-a :initform nil)
   (field-b :accessor field-b :initform nil)
   ))

(defgeneric script1 #|script|# (self))
(defgeneric install-pin #|script|# (self G588))
(defgeneric install-xxx #|script|# (self G589 G590) #|returns boolean|# )
(defgeneric install-yyy #|script|# (self G591 G592) #|returns fake-class|# )
(defgeneric method1 (self))
(defgeneric minstall-pin (self G593))
(defgeneric minstall-xxx (self G594 G595) #|returns boolean|# )
(defgeneric minstall-yyy (self G596 G597) #|returns fake-class|# )


(defmethod install-yyy #|script|# ((self fake-class) x  y )
    (let ((xx  x))
      (setf  a x)
      )#|end let|#
    (block map (dolist (yy  y)
		 ))#|end map|#
    (block map (dolist (yy  y)
		 (return-from map nil)
		 ))#|end map|#
    (setf  a x)
    (let ((b (make-instance 'fake-class)))
      (cond ((esa-expr-true ( install-xxx self  a  b ))
	     ( install-pin self  a )
	     ( minstall self  b )
	     ))#|end if|#
      (cond ((esa-expr-true ( install-xxx self  a  b ))
	     ( install-pin self  a )
	     )
	    (t  #|else|# 
	     (cond ((esa-expr-true ( install-yyy self  a  b ))
		    ( minstall self  b )
		    ))#|end if|#
	     )#|end else|#
	    )#|end if|#
      )#|end create|#
    (loop
       (when (esa-expr-true ( method1 self)) (return))
       )#|end loop|#
    (return-from install-yyy :true)
    (return-from install-yyy :false)
    )#|end script|#
