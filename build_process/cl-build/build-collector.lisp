(in-package :arrowgrams/build)

(defclass build-collector (builder)
  ((name :accessor name)
   (graph :accessor graph)
   (graphs :accessor graphs)
   (leaves :accessor leaves)))

;; ensure that graphs are emitted before leaves (builder must build in reverse order, e.g. top-most graph last)

(defmethod clear ((self build-collector))
  (setf (name self) nil
        (graph self) nil)
  (setf (leaves self) nil)
  (setf (graphs self) nil))

(defmethod e/part:first-time ((self build-collector))
  (clear self)
  (call-next-method))

(defmethod e/part:react ((self build-collector) e)
  ;(format *standard-output* "~&build-collector gets ~S /~s/~%" (@pin self e) (@data self e))
  (ecase (@pin self e)
    (:name
     (assert (null (name self)))
     (setf (name self) (@data self e))
     (maybe-collect-graph self))
    (:graph
     (assert (null (graph self)))
     (setf (graph self) (@data self e))
     (maybe-collect-graph self))     
    (:descriptor
     (collect-leaf self (@data self e)))
    (:done
     (finalize-and-send-collection self))))

(defmethod ensure-not-collecting ((self build-collector))
  (unless (and (null (name self))
               (null (graph self)))
    (let ((msg "build-collector can't happen - out of synch"))
      (@send self :error msg))))

(defmethod maybe-collect-graph ((self build-collector))
  (when (and (name self) (graph self))
    (collect-graph self)
    (setf (name self) nil
          (graph self) nil)))

(defmethod collect-graph ((self build-collector))
  (push (graph-alist self (name self) (graph self)) (graphs self)))

(defmethod collect-leaf ((self build-collector) descriptor-as-json-string)
  (push (json-to-alist descriptor-as-json-string) (leaves self)))

(defmethod send-collection ((self build-collector) list-of-alist kind)
  (dolist (alist list-of-alist)
    (@send self :final-code (alist-to-json-string alist) ))) ;:tag (format nil "build-collector ~s" kind))))

(defmethod finalize-and-send-collection ((self build-collector))
  ;; leaves and graphs are alists
  (send-collection self (graphs self) "leaf")
  (send-collection self (leaves self) "graph")
  (@send self :done t ) ;:tag "build-collector done")
  (clear self))

(defmethod graph-alist ((self build-collector) name json-graph)
;(format *standard-output* "~&graph-alist /~s/~%" json-graph)  
  (let ((alist-graph (json-to-alist json-graph)))
    `( (:item-kind . "graph") (:name . ,name) (:graph . ,alist-graph) )))

(defun apply-commas-make-json-array (lis)
  (if (> (length lis) 1)
      (let ((result (pop lis)))
        (@:loop
          (@:exit-when (null lis))
          (setf result (concatenate 'string result ",
" (pop lis))))  ;; TODO: make this more efficient
        (concatenate 'string "[" result "]"))
    (if (= (length lis) 1)
        (concatenate 'string "[" (car lis) "]")
      "[]")))
  

