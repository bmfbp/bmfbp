(defmacro @loop (&body body) `(loop ,@body))
(defmacro @exit-when (expr) `(when ,expr (return)))

(defmacro new-string-hashmap () `(make-hash-table :test 'equal))

(defmacro source-name (w) `(if (eq 'NULL (second ,w)) "self" (second ,w))) ;; part
(defmacro source-pin-name (w) `(third ,w)) ;; pin
(defmacro sink-name (w) `(if (eq 'NULL (seventh ,w)) "self" (seventh ,w))) ;; part
(defmacro sink-pin-name (w) `(eighth ,w)) ;; pin
(defmacro source-id (w) `(if (eq 'NULL (first ,w)) "self" (first ,w)))
(defmacro sink-id (w) `(if (eq 'NULL (sixth ,w)) "self" (sixth ,w)))
(defmacro wire-number (w) `(fifth ,w))

(defclass part-descriptor-class ()
  ((sinks :accessor sinks :initform (new-string-hashmap))
   (sources :accessor sources :initform (new-string-hashmap))
   (name :accessor name :initform nil)))


  

(defun emit-pin-map (out hashmap)
  (format out "{ ")
  (let ((i 0)
        (first-time t))
    (maphash #'(lambda (pin-name wire-list)
                 (declare (ignore wire-list))
                 (unless first-time
                   (format out ", "))
                 (setf first-time nil)
                 (format out "~S : ~a" pin-name i)
                 (incf i))
             hashmap))
  (format out " }"))


(defun emit-wire-list (out hashmap)
  (format out "[")
  (let ((outer-first-time t))
    (maphash #'(lambda (pin-name wire-list)
                 (declare (ignore pin-name))
                 (unless outer-first-time
                   (format out ","))
                 (setf outer-first-time nil)
                 (format out "[")
                 (let ((first-time t))
                   (@loop
                     (@exit-when (null wire-list))
                     (unless first-time
                       (format out ","))
                     (setf first-time nil)
                     (let ((wire (first wire-list)))
                       (format out "~S" wire))
                     (pop wire-list)))
                 (format out "]"))
           hashmap)
  (format out "]")))

(defun emit-part (out id part-desc)
  (format out "    \"kindName\" : ~S,~%" (if part-desc (name part-desc) "self"))
  (unless (null part-desc)
    (format out "    \"partName\" : \"~A\",~%" id)
    (format out "    \"inCount\" : ~S,~%" (hash-table-count (sinks part-desc)))
    (format out "    \"outCount\" : ~S,~%" (hash-table-count (sources part-desc)))
    (format out "    \"inMap\" : ")
    (emit-pin-map out (sinks part-desc))
    (format out ",~%")
    (format out "    \"outMap\" : ")
    (emit-pin-map out (sources part-desc))
    (format out ",~%")
    (format out "    \"inPins\" : ")
    (emit-wire-list out (sinks part-desc))
    (format out ",~%")
    (format out "    \"outPins\" : ")
    (emit-wire-list out (sources part-desc))
    (format out "~%")))

(defun main0 (strm)
    (let ((whole (read strm))
          (top-level-hashmap (new-string-hashmap)) ;; 'name, 'wirecount, 'metadata, 'wires
          (parts-by-id (new-string-hashmap)) ;; each part including self
          (out *standard-output*))

      ;; top level hashmap contains component Name, Metadata, Wirecount and Wires
      (labels ((get-wires () (gethash 'wires top-level-hashmap))
               (forall-wires (func)
                 (let ((wires (get-wires)))
                   (@loop
                     (@exit-when (null wires))
                     (let ((wire (first wires)))
                       (funcall func wire))
                     (pop wires))))
               (@make-top-level-description ()
                 (@loop
                   (@exit-when (null whole))
                   (setf (gethash (first whole) top-level-hashmap)
                         (second whole))
                   (pop whole)
                   (pop whole)))
               (insert-part (name0 id0)
                 ;; nb "SELF" is represented by 'NULL
                 (let ((name (if (eq 'NULL name0)
                                 "self"
                               name0))
                       (id (if (eq 'NULL name0)
                               "self"
                             id0)))
                   (multiple-value-bind (val success)
                       (gethash id parts-by-id)
                     (declare (ignore val))
                     (unless success
                       (let ((part-desc (make-instance 'part-descriptor-class)))
                         (setf (name part-desc) name
                               (sources part-desc) (new-string-hashmap)
                               (sinks part-desc) (new-string-hashmap))
                         (setf (gethash id parts-by-id) part-desc))))))
               (@insert-parts-into-part-table ()
                 (let ((wire-list (get-wires)))
                   (@loop
                     (@exit-when (null wire-list))
                     (let ((wire (first wire-list)))
                       (insert-part (source-name wire) (source-id wire))
                       (insert-part (sink-name wire) (sink-id wire))
                       (pop wire-list)))))
               (@get-name ()  (gethash 'name top-level-hashmap))
               (@get-wirecount () (gethash 'wirecount top-level-hashmap))
               (@get-metadata () (gethash 'metadata top-level-hashmap))
               (@get-self-descriptor () (gethash "self" parts-by-id))
               (@emit-all-parts-except-self ()
                 (let ((first-time t))
                   (maphash #'(lambda (id part-table)
                                (unless (string= "self" id)
                                  (unless first-time
                                    (format out "  },~%"))
                                  (setf first-time nil)
                                  (format out "  {~%")
                                  (emit-part out id part-table)))
                            parts-by-id))
                   (format out "  }~%"))
               (@insert-source-pin-into-part (wire)
                 (let ((part-id (source-id wire))
                       (pin-name (source-pin-name wire)))
                   (let ((part-desc (gethash part-id parts-by-id)))
                     (let ((sources (sources part-desc)))
                       (setf (gethash pin-name sources) nil)))))
               (@insert-sink-pin-into-part (wire)
                 (let ((part-id (sink-id wire))
                       (pin-name (sink-pin-name wire)))
                   (let ((part-desc (gethash part-id parts-by-id)))
                     (let ((sinks (sinks part-desc)))
                       (setf (gethash pin-name sinks) nil)))))
               (@add-source-wire (wire)
                 (let ((part-id (source-id wire))
                       (pin-name  (source-pin-name wire))
                       (wire-num (wire-number wire)))
                   (let ((part-desc (gethash part-id parts-by-id)))
                     (let ((sources (sources part-desc)))
                       (setf (gethash pin-name sources)
                             (cons wire-num (gethash pin-name sources)))))))
               (@add-sink-wire (wire)
                 (let ((part-id (sink-id wire))
                       (pin-name  (sink-pin-name wire))
                       (wire-num (wire-number wire)))
                   (let ((part-desc (gethash part-id parts-by-id)))
                     (let ((sinks (sinks part-desc)))
                       (setf (gethash pin-name sinks)
                             (cons wire-num (gethash pin-name sinks)))))))
               (@insert-pins-into-parts ()
                 (forall-wires #'@insert-source-pin-into-part)
                 (forall-wires #'@insert-sink-pin-into-part)
                 (forall-wires #'@add-source-wire)
                 (forall-wires #'@add-sink-wire))
               (@flip-sinks-and-sources-for-self ()
                 (let ((desc (@get-self-descriptor)))
                   (unless (null desc)
                     (let ((new-sinks (sources desc))
                           (new-sources (sinks desc)))
                       (setf (sinks desc) new-sinks
                             (sources desc) new-sources))))))
                 
                     

      
        (@make-top-level-description)
        
        ;; collect all parts into a hash table
        (@insert-parts-into-part-table)
        (@insert-pins-into-parts)
      
        (format out "~&{~%")
        ;(format out "  \"partName\" : ~S,~%" (@get-name))
        (format out "  \"wireCount\" : ~S,~%" (@get-wirecount))
        (let ((meta (@get-metadata)))
	  (when meta
	    (format out "  \"metaData\" : ~S,~%" meta)))
        (format out "  \"self\" : {~%")
        (@flip-sinks-and-sources-for-self)
        (emit-part out "self" (@get-self-descriptor))
	(format out "  },~%")
        (format out "  \"parts\" : [~%")
        (@emit-all-parts-except-self)
        (format out "  ]~%")
        (format out "}~%"))))

#-lispworks
(defun main (argv)
  (declare (ignore argv))
  (main0 *standard-input*))
