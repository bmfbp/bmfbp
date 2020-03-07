(in-package :arrowgrams)

(defun loadtime/create-part (kind parent)
  (make-instance 'runtime/part :kind kind :parent parent))

(defmethod runtime/busy-p ((runtime/parts self))
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


;;;;; event ;;;;;;;

(defun runtime/create-event ()
  (make-instance 'runtime/event))

;;;;; dispatcher ;;;;;;;


(defmethod loadtime/memo-top-part ((runtime/dispatcher) instance)
  (ensure-top-empty d)
  (setf (top-part d) instance))

(defmethod loadtime/memo-part ((runtime/dispatcher d) instance)
  (ensure-part-not-already-memoed d instance)
  (push instance (d all-parts)))

(defmethod pre-runtime/initially ((runtime/dispatcher d))
  (mapc #'(lambda (part) (initially part)) (all-parts d))

(defmethod runtime/empty-output-queue-p ((runtime/part p))
  (null (output-queue p)))

(defmethod runtime/distribute-one-output-event ((runtime/part p))
  (let ((output-event (pop (output-queue p))))
    (let ((wire (find-wire-with-source-or-raise-error schematic p (pin output-event))))
      (runtime/distribute-output-event wire (schematic p output-event)))))
    
(defmethod runtime/distribute-output-event ((runtime/wire wire) (runtime/part schematic) (runtime/part p) output-event)
  (let ((data (data output-event)))
    (mapc #'(lambda (destination)
	      (runtime/distribute-data-to-destination destination data))
	  (destinations wire))))

(defmethod runtime/distribute-data-to-destination ((runtime/part schematic) destination-pair data)
  (let ((part-name (part destination-pair))
	(pin-name  (pin  destination-pair)))
    (let ((part-instance (lookup-part-name schematic part-name)))
      (let ((new-event (runtime/create-event :pin pin-name :data data)))
	(runtime/enqueue-input part-instance new-event)))))

(defmethod runtime/enqueue-input ((runtime/part p) e)
  (push (input-queue p) e))

(defmethod runtime/distribute-outputs-from-part ((runtime/part p))
  (@:loop
   (@:exit-when (runtime/empty-output-queue-p p))
   (runtime/distribute-one-output-event p)))

(defmethod runtime/distribute-all-outputs ((runtime/dispatcher d))
  (dolist (p (all-parts d))
    (when (has-outputs-p p)
      (setf no-more nil)
      (runtime/distribute-outputs-from-part p))))

(defmethod runtime/dispatch ((runtime/dispatcher d))
  (let ((no-more-flag nil))
    (@:loop
     (@:exit-when no-more)
     (setf no-more-flag T)
     (let ((p (all-parts d)))
       (when (ready-p p)
	 (setf not-more-flag nil)
	 (runtime/invoke p)
	 (runtime/distribute-output-q p))))))

(defmethod runtime/invoke ((runtime/part p))
  (let ((e (pop (input-queue p))))
    (runtime/react p e)))

(defmethod runtime/ready-p ((runtime/part p))
  (and (input-queue p)
       (not (busy-p p))))

(defmethod runtime/has-outputs-p ((runtime/part p))
  (output-queue p))

(defmethod lookup-part-name ((runtime/part schematic) part-name)
  (multiple-value-bind (instance success)
      (gethash part-name (parts schematic))
    (unless success
      (error "part ~s not found in ~s" part-name schematic))
    instance))


;====== helpers and errors =======

(defmethod ensure-part-name-not-used ((runtime/part schematic) part-name)
  (multiple-value-bind (instance success)
      (gethash part-name (parts schematic))
    (when success
      (error "cannot multily define part ~s in ~s" part-name schematic))))

(defmethod ensure-part-not-already-memoed ((runtime/dispatcher d) instance)
  (when (member instance (all-parts d))
    (error "attempt to memo part ~s which is already in memo list of ~s" instance d)))

(defmethod find-wire-with-source-or-raise-error ((runtime/part schematic) p pin-name)
  (dolist (w (wires schematic))
    (let ((wire-source (source wire))
	  (search-pair (create-part-pin-pair :part p :pin pin-name)))
      (when (definition/pair-eq search-pair wire-source)
	(return-from find-wire-with-source-or-raiser-error w))))
  (error "could not find part ~s pin ~s in sources of wires for ~s"
	 p pin-name schematic))
