(in-package :arrowgrams/build)

(defclass build-collector (builder)
  ((name :accessor name)
   (graph :accessor graph)
   (graphs :accessor graphs)
   (leaves :accessor leaves)))

;; ensure that leaves are emitted before graphs (builder must build in reverse order, e.g. top-most graph last)

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
    (:leaf-json-ref
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

(defmethod collect-leaf ((self build-collector) file-ref)
  (push (leaf-alist self file-ref) (leaves self)))

(defmethod send-collection ((self build-collector) collection)
  (let ((list-of-strings collection))
    (let ((jstring (apply-commas-make-json-array list-of-strings)))
      (@send self :json-collection jstring :tag "build-collector json"))))

(defmethod finalize-and-send-collection ((self build-collector))
  (send-collection self (leaves self))
  (send-collection self (graphs self))
  (@send self :done t :tag "build-collector done")
  (clear self))

(defmethod leaf-alist ((self build-collector) file-ref-pathname)
  ;; file-ref is a pathname like #P"/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/split_diagram.lisp"
  ;; result is a string JSON map with 3 items
  (let ((file-ref-str (namestring file-ref-pathname)))
    (let ((name (pathname-name file-ref-pathname)))
      (json:encode-json-to-string `( (:item-kind . "leaf") (:name . ,name) (:file-name . ,file-ref-str))))))

(defmethod graph-alist ((self build-collector) name json-graph)
;(format *standard-output* "~&graph-alist /~s/~%" json-graph)  
  (let ((alist-graph (with-input-from-string (s json-graph) (json:decode-json s))))
    (json:encode-json-to-string `( (:item-kind . "graph") (:name . ,name) (:graph . ,alist-graph) ))))

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
  

