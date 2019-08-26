(defmacro @loop (&body body) `(loop ,@body))
(defmacro @exit-when (expr) `(when ,expr (return)))

(defmacro new-string-hashmap () `(make-hash-table :test equal))

(defclass part-descriptor-class ()
  ((sinks :accessor sinks :initform (new-string-hashmap))
   (sources :accessor sources :initform (new-string-hashmap))
   (id :accessor id :initform nil)))

(defun main ()
  (with-open-file (t27 "~/projects/bmfbp/svg/js-compiler/temp27.lisp" :direction :input)
    (let ((whole (read t27))
          (top-level-hashmap (new-string-hashmap)) ;; 'name, 'wirecount, 'metadata, 'wires
          (parts-table (new-string-hashmap)) ;; each part including self
          (out *standard-output*))

      ;; top level hashmap contains component Name, Metadata, Wirecount and Wires
      (labels ((@forall-wires-associate-input-and-output-pins-with-parts ()
                 (let ((wire-list (gethash 'wires top-level-hashmap)))
                   (@loop
                     (@exit-when (null wire-list))
                     (associate-pins-given-wire top-level-hashmap wire)
                     (pop wire-list))))
               (@make-top-level-description ()
                 (@loop
                   (@exit-when (null whole))
                   (setf (gethash (first whole) top-level-hashmap)
                         (second whole))
                   (pop whole)
                   (pop whole)))
               (@insert-part-names-into-part-table()
                 (insert-part-names parts-table (gethash 'wires hashmap)))
               (@get-name ()  (gethash 'name top-level-hashmap))
               (@get-wirecount () (gethash 'wirecount top-level-hashmap))
               (@get-metadata () (gethash 'metadata top-level-hashmap))
               (@get-self-descriptor () (gethash "self" parts-by-name))
               (@emit-all-parts-except-self ()
                 (maphash #'(lambda (name part-table)
                              (unless (string= "self" name)
                                (format out "  {~%")
                                (emit-part out name part-table)
                                (format out "  }~%")))
                          parts-by-name)))

      
        (@make-top-level-description)
      
        ;; collect all parts into a hash table
        (@insert-part-names-into-part-table)
      
        ;; annotate each part with its pins
        (@forall-wires-associate-input-and-output-pins-with-parts)
      
        (format out "~&{~%")
        (format out "  \"partName\" : ~S,~%" (@get-name))
        (format out "  \"wireCount\" : ~S,~%" (@get-wirecount))
        (format out "  \"metaData\" : ~S,~%" (@get-metadata))
        (format out "  \"self\" :~%")
        (emit-part out "self" (@get-self-descriptor))
        (format out "  \"parts\" : [~%")
        (@emit-all-parts-except-self)
        (format out "  ]~%")
        (format out "},~%")))))
  
(defun emit-part (out name part-table)
  (format out "    \"partName\" : ~S~%" (gethash :id part-table))
  (format out "    \"kindName\" : ~S~%" name))

(defmacro source-name (w) `(second ,w))
(defmacro source-pin-name (w) `(third ,w))
(defmacro sink-name (w) `(seventh ,w))
(defmacro sink-pin-name (w) `(eighth ,w))
(defmacro source-id (w) `(first ,w))
(defmacro sink-id (w) `(sixth ,w))
(defmacro wire-number (w) `(fifth w))

(defun associate-pins-given-wire (part-table wire)
  (let ((sink-part-name (sink-name-wire))
        (sink-pin-name (sink-pin-name wire))
        (source-part-name (source-name wire))
        (source-pin-name (source-pin-name wire))
        (wire-number (wire-number wire)))
    (install-pin-if-not-present part-table :sinks sink-part-name sink-pin-name)
    (install-pin-if-not-present part-table :sources source-part-name source-pin-name)
    (push-wire-number part-table :sinks sink-part-name sink-pin-name)
    (push-wire-number part-table :sources source-part-name source-pin-name)))

(defun install-pin-if-not-present (part-table direction-id part-name pin-name)
  (multiple-value-bind (part-descriptor-hash success)
      (gethash part-table part-name)
    (assert success) ;; part should already be in the table
    (multiple-value-bind (sink-or-souce-pins-hash
    

(defun @insert-part-names (table wire-list)
  "put every part into the table with nil :source and :sink fields, and :id field set to Prolog id or 'self'"
  (@loop
    (@exit-when (null wire-list))
    (let ((wire (first wire-list)))
      (insert-part-name table (source-name wire) (source-id wire))
      (insert-part-name table (sink-name wire) (sink-id wire))
    (pop wire-list))))

(defun insert-part-name (table name0 id0)
  ;; nb "SELF" is represented by 'NULL
  (let ((name (if (eq 'NULL name0)
                  "self"
                name0))
        (id (if (eq 'NULL name0)
                "self"
              id0)))
    (multiple-value-bind (val success)
        (gethash name table)
      (declare (ignore val))
      (unless success
        (let ((part-table (make-hash-table)))
          (make-instance 'part-table-class)
          (setf (gethash name table) part-table))))))

#|
    {
      "partname" : " js_test6_emitter",
      "wireCount" : 6,
      "metadata" : [...],
      "self" : {
          "partName" : "self",
          "kindName" : "js_test6_emitter",
          "inCount" : 1,
          "outCount" : 1,
          "inPins" :  [[],[],[],[wire 0],[],[]],
          "outPins" : [[],[],[],[],[],[wire 5]]
        },
        "parts" : [
          {
            "kindName" : "part1",
            "partName" : "ID397",
            "inCount"  : ,
            "outCount" : ,
            "inPins"   : ,
            "outPins"  : ,
          },
          {
            "kindName" : "part2",
            "partName" : "ID397",
            "inCount"  : ,
            "outCount" : ,
            "inPins"   : ,
            "outPins"  : ,
          },
          {
            "kindName" : "part3",
            "partName" : "ID374",
            "inCount"  : ,
            "outCount" : ,
            "inPins"   : ,
            "outPins"  : ,
          },
          {
            "kindName" : "part4",
            "partName" : "ID369",
            "inCount"  : 2,
            "outCount" : 1,
            "inPins"   : { "p14" : [3], "p10" : [5,6] },
            "outPins"  : { "p11" : [0,7] },
          }
        ]
      }
    }
|#

#|  
{
  "partName": "ID374",
  "wireCount": 4,
  "self": {
    "kindName": "pass_and_add",
    "inCount": 3,
    "outCount": 1,
    "inPins": [[0], [1], [2]],
    "outPins": [[0, 3]]
  },
  "parts": [
    {
      "kindName": "add_1",
      "inCount": 1,
      "outCount": 1,
      "inPins": [[1]],
      "outPins": [[3]],
    }
  ]
}
|#           