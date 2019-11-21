;;INPUTS
;; (:file-name "string") opens file and sends stream to :stream
;; (:read  T)            read one item from file, send it to :object
;; (:close T)            close file, removes internal memory of *stream*
;;
;;OUTPUTS
;; (:stream stream)      the Lisp stream
;; (:object T)           a Lisp object
;; (:done T)             EOF, send :FATAL if receive anything but :file-name
;; (:fatal object)       some fatal error, "object" specifies error details (NIY (not implemented yet))


(in-package :cl-event-passing-user)

(defparameter *stream* nil)
(defparameter *state* 'idle)

(defmethod filestream-reset ((self e/part:part))
  (declare (ignore part))
  (setf *state* 'idle))

(defmethod filestream ((self e/part:part) (e e/event:event))
  (let ((data (e/event:data e))
        (action (e/event::sym e)))

    (e/util::logging (format nil "filestream action=~S data=~S" action data))

    (case *state*

      (idle
           (case action
             (:file-name (let ((in (open data :direction :input)))
                           (setf *stream* in)
                           (@send self :stream in)
                           (setf *state* 'open)))
             (otherwise  (@send self :fatal t))))

      (open
           (case action
             (:read (let ((object (read *stream* nil 'EOF)))
                      (if (eq object 'EOF)
                          (@send self :done t) ;; nb - don't close, send message to self
                        (@send self :object object))))

             (:close (setf *stream* nil)
              (setf *state* 'idle))

             (otherwise (@send self :fatal t))))
      
       (otherwise (@send self :fatal t)))))

