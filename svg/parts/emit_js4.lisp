(defmacro @loop (&body body) `(loop ,@body))
(defmacro @exit-when (expr) `(when ,expr (return)))

(defun main ()
  (with-open-file (t27 "~/projects/bmfbp/svg/js-compiler/temp27.lisp" :direction :input)
    (let ((whole (read t27))
          (hashmap (make-hash-table))
          (parts-by-name (make-hash-table :test 'equal))
          (out *standard-output*))

      ;; top level hashmap contains component Name, Metadata, Wirecount and Wires
      (@loop
        (@exit-when (null whole))
        (setf (gethash (first whole) hashmap)
              (second whole))
        (pop whole)
        (pop whole))

      ;; collect all parts into a hash table
      (@insert-part-names parts-by-name (gethash 'wires hashmap))


     (format out "~&{~%")
     (format out "  \"partName\" : ~S,~%" (gethash 'name hashmap))
     (format out "  \"wireCount\" : ~S,~%" (gethash 'wirecount hashmap))
     (format out "  \"metaData\" : ~S,~%" (gethash 'metadata hashmap))
     (format out "  \"self\" :~%")
       (emit-part out "self" (gethash "self" parts-by-name))
     (format out "  \"parts\" : [~%")
     (maphash #'(lambda (name part-table)
                  (unless (string= "self" name)
                    (format out "  {~%")
                    (emit-part out name part-table)
                    (format out "  }~%")))
              parts-by-name)
     (format out "  ]~%")
     (format out "},~%"))))

(defun emit-part (out name part-table)
  (format out "    \"partName\" : ~S~%" (gethash :id part-table))
  (format out "    \"kindName\" : ~S~%" name))

(defmacro source-name (w) `(second ,w))
(defmacro sink-name (w) `(seventh ,w))
(defmacro source-id (w) `(first ,w))
(defmacro sink-id (w) `(sixth ,w))

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
          (setf (gethash :sink part-table) nil
                (gethash :source part-table) nil
                (gethash :id part-table) id)
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
            "kindName" : "assign_wire_numbers_to_inputs",
            "partName" : "ID397",
            "inCount"  : ,
            "outCount" : ,
            "inPins"   : ,
            "outPins"  : ,
          },
          {
            "kindName" : "assign_wire_numbers_to_output",
            "partName" : "ID397",
            "inCount"  : ,
            "outCount" : ,
            "inPins"   : ,
            "outPins"  : ,
          },
          {
            "kindName" : "assign_port_indices",
            "partName" : "ID374",
            "inCount"  : ,
            "outCount" : ,
            "inPins"   : ,
            "outPins"  : ,
          },
          {
            "kindName" : "emit",
            "partName" : "ID369",
            "inCount"  : ,
            "outCount" : ,
            "inPins"   : ,
            "outPins"  : ,
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