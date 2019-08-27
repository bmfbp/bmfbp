(defmacro @loop (&body body) `(loop ,@body))
(defmacro @exit-when (expr) `(when ,expr (return)))

(defmacro new-string-hashmap () `(make-hash-table :test 'equal))

(defmacro source-name (w) `(if (eq 'NULL (second ,w)) "self" (second ,w))) ;; part
(defmacro source-pin-name (w) `(third ,w)) ;; pin
(defmacro sink-name (w) `(if (eq 'NULL (seventh ,w)) "self" (seventh ,w))) ;; part
(defmacro sink-pin-name (w) `(eighth ,w)) ;; pin
(defmacro source-id (w) `(first ,w))
(defmacro sink-id (w) `(sixth ,w))
(defmacro wire-number (w) `(fifth ,w))

(defclass part-descriptor-class ()
  ((sinks :accessor sinks :initform (new-string-hashmap))
   (sources :accessor sources :initform (new-string-hashmap))
   (id :accessor id :initform nil)))


  

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

(defun emit-part (out name part-desc)
  (format out "    \"kindName\" : ~S,~%" name)
  (unless (null part-desc)
    (format out "    \"partName\" : ~S,~%" (id part-desc))
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
          (parts-by-name (new-string-hashmap)) ;; each part including self
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
               (insert-part-name (name0 id0)
                 ;; nb "SELF" is represented by 'NULL
                 (let ((name (if (eq 'NULL name0)
                                 "self"
                               name0))
                       (id (if (eq 'NULL name0)
                               "self"
                             id0)))
                   (multiple-value-bind (val success)
                       (gethash name parts-by-name)
                     (declare (ignore val))
                     (unless success
                       (let ((part-desc (make-instance 'part-descriptor-class)))
                         (setf (id part-desc) id
                               (sources part-desc) (new-string-hashmap)
                               (sinks part-desc) (new-string-hashmap))
                         (setf (gethash name parts-by-name) part-desc))))))
               (@insert-part-names-into-part-table ()
                 (let ((wire-list (get-wires)))
                   (@loop
                     (@exit-when (null wire-list))
                     (let ((wire (first wire-list)))
                       (insert-part-name (source-name wire) (source-id wire))
                       (insert-part-name (sink-name wire) (sink-id wire))
                       (pop wire-list)))))
               (@get-name ()  (gethash 'name top-level-hashmap))
               (@get-wirecount () (gethash 'wirecount top-level-hashmap))
               (@get-metadata () (gethash 'metadata top-level-hashmap))
               (@get-self-descriptor () (gethash "self" parts-by-name))
               (@emit-all-parts-except-self ()
                 (let ((first-time t))
                   (maphash #'(lambda (name part-table)
                                (unless (string= "self" name)
                                  (unless first-time
                                    (format out "  },~%"))
                                  (setf first-time nil)
                                  (format out "  {~%")
                                  (emit-part out name part-table)))
                            parts-by-name))
                   (format out "  }~%"))
               (@insert-source-pin-into-part (wire)
                 (let ((part-name (source-name wire))
                       (pin-name (source-pin-name wire)))
                   (let ((part-desc (gethash part-name parts-by-name)))
                     (let ((sources (sources part-desc)))
                       (setf (gethash pin-name sources) nil)))))
               (@insert-sink-pin-into-part (wire)
                 (let ((part-name (sink-name wire))
                       (pin-name (sink-pin-name wire)))
                   (let ((part-desc (gethash part-name parts-by-name)))
                     (let ((sinks (sinks part-desc)))
                       (setf (gethash pin-name sinks) nil)))))
               (@add-source-wire (wire)
                 (let ((part-name (source-name wire))
                       (pin-name  (source-pin-name wire))
                       (wire-num (wire-number wire)))
                   (let ((part-desc (gethash part-name parts-by-name)))
                     (let ((sources (sources part-desc)))
                       (setf (gethash pin-name sources)
                             (cons wire-num (gethash pin-name sources)))))))
               (@add-sink-wire (wire)
                 (let ((part-name (sink-name wire))
                       (pin-name  (sink-pin-name wire))
                       (wire-num (wire-number wire)))
                   (let ((part-desc (gethash part-name parts-by-name)))
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
        (@insert-part-names-into-part-table)
        (@insert-pins-into-parts)
      
        (format out "~&{~%")
        (format out "  \"partName\" : ~S,~%" (@get-name))
        (format out "  \"wireCount\" : ~S,~%" (@get-wirecount))
        (format out "  \"metaData\" : ~S,~%" (@get-metadata))
        (format out "  \"self\" :~%")
        (@flip-sinks-and-sources-for-self)
        (emit-part out "self" (@get-self-descriptor))
        (format out "  \"parts\" : [~%")
        (@emit-all-parts-except-self)
        (format out "  ]~%")
        (format out "},~%"))))

#-lispworks
(defun main (argv)
  (declare (ignore argv))
  (main0 *standard-input*))

#|
    {
      "partname" : " js_test6_emitter",
      "wireCount" : 8,
      "metadata" : [...],
      "self" : {
          "partName" : "self",
          "kindName" : "js_test6_emitter",
          "inCount" : 1,
          "outCount" : 2,
          "inPins" :  [[0]], // p3 == index 0
          "outPins" : [[0],[7]] // p12 == index 0, p16 == index 1 
        },
        "parts" : [
          {
            "kindName" : "part1",
            "partName" : "ID411",
            "inCount"  : 1,
            "outCount" : 2,
            "inMap"    : { "p4" : 0 }
            "outMap    : { "p13" : 0, "p5" : 1 }
            "inPins"   : [[1]],
            "outPins"  : [[3],[2]]
          },
          {
            "kindName" : "part2",
            "partName" : "ID394",
            "inCount"  : 1,
            "outCount" : 2,
            "inMap"    : { "p6" : 0 }
            "outMap"   : { "p7" : 0, "p15" : 1 }
            "inPins"   : [[2]],
            "outPins"  : [[4],[5]]
          },
          {
            "kindName" : "part3",
            "partName" : "ID381",
            "inCount"  : 1,
            "outCount" : 1,
            "inMap"    : { "p8" : 0 }
            "outMap"   : { "p9" : 0 }
            "inPins"   : [[4]],
            "outPins"  : [[6]]
          },
          {
            "kindName" : "part4",
            "partName" : "ID374",
            "inCount"  : 2,
            "outCount" : 1,
            "inMap"    : { "p14" : 0, "p10" : 1 }
            "outMap"   " { "p11" : 0 }
            "inPins"   : [[3], [5,6]],
            "outPins"  : [[0,7]]
          }
        ]
      }
    }
|#

