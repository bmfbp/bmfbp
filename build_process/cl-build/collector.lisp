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
  (push (list :graph (cons (name self) (graph self))) (collection self)))

(defmethod collect-leaf ((self collector) file-ref)
  (push (list :leaf file-ref) (collection self)))

(defmethod finalize-and-send-collection ((self collector))
  (let ((list (collection self)))
    (let ((jstring (with-output-to-string (stream)
                     (@:loop
                       (@:exit-when (null list))
                       (let ((pair (pop list)))
                         (let ((kind (first pair)))
                           (let ((data (second pair)))
                             (ecase kind
                               (:leaf
                                (finalize-leaf self data stream))
                               (:graph
                                (finalize-graph self data stream))))))))))
      (@send self :json-collection jstring)
      (e/part:first-time self))))


(defmethod finalize-leaf ((self collector) file-ref-pathname json-stream)
  ;; file-ref is a pathname like #P"/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/split_diagram.lisp"
  ;; result is a dotted pair (alist)
  (let ((file-ref-str (coerce 'string file-ref-pathaname)))
    (json:encode-json (cons :file file-ref) json-stream)))

(defmethod finalize-graph ((self collector) name-graph-dotted-pair json-stream)
  ;; result is a dotted pair ("graph" . <object>)
  (let ((graph-string (arrowgrams/compiler:strip-quotes (cdr name-graph-dotted-pair))))
    (let ((name (car name-graph-dotted-pair)))
      (with-input-from-string (s graph-string)
        (let ((jalist (json:decode-json s))) ;; TODO: optimize this away
          (let ((alist (cons :graph (cons name graph-string))))
            (json:encode-json alist json-stream)))))))


