(in-package :arrowgrams)

(defclass loader (cl-messaging:part)
  ((parts-table :accessor parts-table)
   (cwd :initform "." :accessor cwd)))

(defmethod initialize-instance :after ((self loader) &key)
  (setf (slot-value self 'parts-table) (make-hash-table :test 'equal)))

(defmethod respond ((self loader) (message cl-messaging:message))
  (case (cl-messaging:pin message)

    (:cwd
     ;; set/change working directory
     (setf (cwd self) (cl-messaging:data message)))

    (:perform-load
     (perform-load self (cl-messaging:data message)))

    (otherwise
     (error "Message not implemented"))))


(defun @convert-filenames-to-pathnames (file-names-list working-directory)
  (let ((result nil))
    (@:loop
     (@:exit-when (null file-names-list))
     (let ((name (pop file-names-list)))
       (push (merge-pathnames name :default-pathname working-directory) result)))
    result))

(defmethod perform-load ((self loader) filenames)
  (let ((pathnames (@convert-filenames-to-pathnames filenames (cwd self))))
    pathnames))
