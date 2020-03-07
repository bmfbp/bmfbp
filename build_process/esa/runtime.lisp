(in-package :arrowgrams)

;; input events can only appear on the input queue of a part, in that case, the pin field refers to the receiving part
;; output events can only appear on the output queue of a prt, in that case, the pin field refers to the sending part
(defclass runtime/event ()
  ((pin :accessor pin)  
   (data :accessor data)))

(defclass runtime/part ()
  ((kind :accessor kind :initarg :kind)
   (input-queue :accessor input-queue :initform nil)
   (output-queue :accessor output-queue :initform nil)
   (parts :accessor parts :initform (make-hash-table :test 'equal))
   (parent :accessor parent :initarg :parent)))

(defun loadtime/create-part (kind parent)
  (make-instance 'runtime/part :kind kind :parent parent))

(defmethod runtime/busy ((runtime/parts self))
  (if (zerop (hash-table-count (parts self)))
      nil
      (some #'busy (parts (self)))))  ;; a composite is busy if any of its children are busy

(defmethod loadtime/instantiate-top ((runtime/part top))
  (let ((tree (loadtime/instantiate top)))
  (pre-runtime/memo-top-part tree)
  tree))

(defmethod loadtime/instantiate ((self runtime/part))
  (let ((selfkind (kind self)))
    (maphash #'(lambda (name kind)
		 (let ((instance (runtime/create-part :kind kind :parent self)))
		   (runtime/instantiate instance)
		   (ensure-part-name-not-used self name)
		   (setf (gethash name (parts self)) instance)
		   (loatime/memo-part instance)))
	     (parts selfkind))))


;;;;; dispatcher ;;;;;;;

(defparameter *loadtime/top-part* nil)
(defparameter *loadtime/all-parts* nil)

(defun loadtime/memo-top-part (instance)
  (ensure-top-empty)
  (setf *loadtime/top-part* instance))

(defun loadtime/memo-part (instance)
  (ensure-part-not-already-memoed instance)
  (push instance *loadtime/all-parts*))

(defun pre-runtime/initially ()
  (mapc #'(lambda (part) (initially part)) (*loadtime/all-parts*)))




		   (ensure-part-name-not-used self name)
      (ensure-part-not-already-memoed instance)
