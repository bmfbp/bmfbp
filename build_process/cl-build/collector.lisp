(in-package :arrowgrams/build)

(defclass collector (builder)
  ((name :accessor name)
   (graph :accessor graph)
   (collection :accessor collection)))

(defmethod e/part:first-time ((self collector))
  (setf (name self) nil
        (graph self) nil)
  (setf (collection self) nil)
  (call-next-method))

(defmethod e/part:react ((self collector) e)
  (format *standard-output* "~&collector gets ~S /~s/~%" (@pin self e) (@data self e))
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

(defmethod ensure-not-collecting ((self collector))
  (unless (and (null (name self))
               (null (graph self)))
    (let ((msg "collector can't happen - out of synch"))
      (@send self :error msg))))

(defmethod maybe-collect-graph ((self collector))
  (when (and (name self) (graph self))
    (collect-graph self)
    (setf (name self) nil
          (graph self) nil)))

(defmethod collect-graph ((self collector))
  (push (graph-alist self (name self) (graph self)) (collection self)))

(defmethod collect-leaf ((self collector) file-ref)
  (push (leaf-alist self file-ref) (collection self)))

(defmethod finalize-and-send-collection ((self collector))
  (let ((list-of-strings (reverse (collection self))))
    (let ((jstring (apply-commas-make-json-array list-of-strings)))
      #+nil(with-open-file (f "/tmp/temp.txt" :direction :output :if-exists :supersede)
        (write jstring :stream f))
      (@send self :json-collection jstring)
      (e/part:first-time self))))

(defmethod leaf-alist ((self collector) file-ref-pathname)
  ;; file-ref is a pathname like #P"/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/split_diagram.lisp"
  ;; result is a string JSON map with 3 items
  (let ((file-ref-str (namestring file-ref-pathname)))
    (let ((name (pathname-name file-ref-pathname)))
      (json:encode-json-to-string `( (:item-kind . "leaf") (:name . ,name) (:file-name . ,file-ref-str))))))

(defmethod graph-alist ((self collector) name json-graph)
  (let ((alist-graph (with-input-from-string (s json-graph) (json:decode-json s))))
    (json:encode-json-to-string `( (:item-kind . "graph") (:name . ,name) (:graph . ,alist-graph) ))))

(defun apply-commas-make-json-array (lis)
  (assert (> (length lis) 1))
  (let ((result (pop lis)))
    (@:loop
      (@:exit-when (null lis))
      (setf result (concatenate 'string result ",
" (pop lis))))  ;; TODO: make this more efficient
    (concatenate 'string "[" result "]")))

